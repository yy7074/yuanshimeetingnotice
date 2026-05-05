import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { User, UserRole } from './entities/user.entity';
import { EmailService } from '../common/email.service';
import { Notification } from '../notifications/entities/notification.entity';
import { CheckIn } from '../check-in/entities/check-in.entity';

describe('UsersService', () => {
  let service: UsersService;
  let repo: {
    findOne: jest.Mock;
    save: jest.Mock;
    create: jest.Mock;
    createQueryBuilder: jest.Mock;
    count: jest.Mock;
    find: jest.Mock;
  };
  let notifRepo: {
    find: jest.Mock;
    count: jest.Mock;
  };
  let checkInRepo: {
    find: jest.Mock;
    count: jest.Mock;
  };

  beforeEach(async () => {
    repo = {
      findOne: jest.fn(),
      save: jest.fn(),
      create: jest.fn((value) => value),
      createQueryBuilder: jest.fn(),
      count: jest.fn(),
      find: jest.fn(),
    };
    notifRepo = {
      find: jest.fn(),
      count: jest.fn(),
    };
    checkInRepo = {
      find: jest.fn(),
      count: jest.fn(),
    };

    const moduleRef = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(User),
          useValue: repo,
        },
        {
          provide: getRepositoryToken(Notification),
          useValue: notifRepo,
        },
        {
          provide: getRepositoryToken(CheckIn),
          useValue: checkInRepo,
        },
        {
          provide: EmailService,
          useValue: {
            sendInvitationEmail: jest.fn(),
          },
        },
      ],
    }).compile();

    service = moduleRef.get(UsersService);
  });

  it('updates admin-managed user fields and normalizes email', async () => {
    const user = {
      id: 'u1',
      email: 'old@example.com',
      password: 'hashed',
      nameEn: '',
      nameZh: '',
      titleEn: '',
      titleZh: '',
      organizationEn: '',
      organizationZh: '',
      avatarUrl: '',
      role: UserRole.ATTENDEE,
      isActive: true,
      pushEnabled: true,
      language: 'zh',
      fcmToken: null,
    } as User;

    repo.findOne
      .mockResolvedValueOnce(user)
      .mockResolvedValueOnce(null);
    repo.save.mockImplementation(async (value) => value);

    const result = await service.updateByAdmin('u1', {
      email: ' NEW@EXAMPLE.COM ',
      nameEn: ' Alice ',
      language: 'en',
      pushEnabled: false,
    });

    expect(repo.save).toHaveBeenCalled();
    expect(result.email).toBe('new@example.com');
    expect(result.nameEn).toBe('Alice');
    expect(result.language).toBe('en');
    expect(result.pushEnabled).toBe(false);
    expect((result as any).password).toBeUndefined();
  });

  it('creates a user with a hashed password from admin input', async () => {
    repo.findOne.mockResolvedValueOnce(null);
    repo.save.mockImplementation(async (value) => value);

    const result = await service.createByAdmin({
      email: ' NEW@EXAMPLE.COM ',
      password: 'Welcome2026!',
      nameEn: ' Alice ',
      role: UserRole.SPEAKER,
      language: 'en',
      isActive: false,
      pushEnabled: false,
    });

    expect(result.email).toBe('new@example.com');
    expect(result.nameEn).toBe('Alice');
    expect(result.role).toBe(UserRole.SPEAKER);
    expect(result.language).toBe('en');
    expect(result.isActive).toBe(false);
    expect(result.pushEnabled).toBe(false);
    expect((repo.save.mock.calls[0][0] as User).password).not.toBe('Welcome2026!');
  });

  it('blocks deactivating the current admin account', async () => {
    await expect(service.updateActive('u1', false, 'u1')).rejects.toThrow(
      'Cannot deactivate the current admin account',
    );
  });

  it('updates user active status in batch', async () => {
    const users = [
      { id: 'u1', isActive: true },
      { id: 'u2', isActive: true },
    ] as User[];
    repo.find.mockResolvedValueOnce(users);
    repo.save.mockImplementation(async (value) => value);

    const result = await service.updateActiveBatch(['u1', 'u2'], false, 'admin');

    expect(result).toEqual({ updated: 2, isActive: false });
    expect(users[0].isActive).toBe(false);
    expect(users[1].isActive).toBe(false);
    expect(repo.save).toHaveBeenCalledWith(users);
  });

  it('updates user role in batch', async () => {
    const users = [
      { id: 'u1', role: UserRole.ATTENDEE },
      { id: 'u2', role: UserRole.VIP },
    ] as User[];
    repo.find.mockResolvedValueOnce(users);
    repo.save.mockImplementation(async (value) => value);

    const result = await service.updateRoleBatch(['u1', 'u2'], UserRole.SPEAKER, 'admin');

    expect(result).toEqual({ updated: 2, role: UserRole.SPEAKER });
    expect(users[0].role).toBe(UserRole.SPEAKER);
    expect(users[1].role).toBe(UserRole.SPEAKER);
    expect(repo.save).toHaveBeenCalledWith(users);
  });

  it('blocks batch demotion of the current admin account', async () => {
    await expect(
      service.updateRoleBatch(['admin'], UserRole.SPEAKER, 'admin'),
    ).rejects.toThrow('Cannot change the current admin account to a non-admin role');
  });

  it('resets a user password with a new hash', async () => {
    const user = {
      id: 'u1',
      email: 'user@example.com',
      password: 'old-hash',
    } as User;
    repo.findOne.mockResolvedValueOnce(user);
    repo.save.mockImplementation(async (value) => value);

    const result = await service.resetPasswordByAdmin('u1', 'NewPassw0rd123');

    expect(result.message).toBe('Password reset successfully.');
    expect(user.password).not.toBe('NewPassw0rd123');
    expect(repo.save).toHaveBeenCalledWith(user);
  });

  it('returns overview stats with total check-ins instead of recent list length', async () => {
    repo.findOne.mockResolvedValueOnce({
      id: 'u1',
      email: 'user@example.com',
      password: 'hashed',
      subscribedEvents: [
        {
          id: 'e1',
          titleEn: 'Event One',
          titleZh: '会议一',
          startDate: new Date('2026-05-20T09:00:00.000Z'),
          endDate: new Date('2026-05-20T17:00:00.000Z'),
          status: 'published',
        },
      ],
    } as unknown as User);
    notifRepo.find.mockResolvedValueOnce([
      {
        id: 'n1',
        titleEn: 'Reminder',
        titleZh: '提醒',
        type: 'schedule_reminder',
        isRead: false,
        createdAt: new Date('2026-05-20T08:45:00.000Z'),
      },
    ]);
    checkInRepo.find.mockResolvedValueOnce([
      {
        id: 'c1',
        eventId: 'e1',
        checkedInAt: new Date('2026-05-20T08:58:00.000Z'),
        event: { titleEn: 'Event One', titleZh: '会议一' },
      },
    ]);
    notifRepo.count.mockResolvedValueOnce(1);
    checkInRepo.count.mockResolvedValueOnce(5);

    const result = await service.getOverview('u1');

    expect(result.stats.subscribedEventsCount).toBe(1);
    expect(result.stats.unreadNotificationCount).toBe(1);
    expect(result.stats.checkInCount).toBe(5);
    expect(result.recentCheckIns).toHaveLength(1);
  });
});
