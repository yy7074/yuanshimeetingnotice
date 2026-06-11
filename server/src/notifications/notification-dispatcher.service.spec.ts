import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotificationDispatcherService } from './notification-dispatcher.service';
import { Notification, NotificationType } from './entities/notification.entity';
import { User, UserRole } from '../users/entities/user.entity';
import { PushService } from '../common/push.service';
import { EmailService } from '../common/email.service';

describe('NotificationDispatcherService', () => {
  let service: NotificationDispatcherService;
  let userRepo: {
    find: jest.Mock;
    findOne: jest.Mock;
    createQueryBuilder: jest.Mock;
  };
  let notifRepo: {
    create: jest.Mock;
    save: jest.Mock;
  };
  let pushService: {
    sendToDevice: jest.Mock;
    sendToTag: jest.Mock;
    sendToAll: jest.Mock;
  };

  beforeEach(async () => {
    userRepo = {
      find: jest.fn(),
      findOne: jest.fn(),
      createQueryBuilder: jest.fn(),
    };
    notifRepo = {
      create: jest.fn((value) => value),
      save: jest.fn(async (value) => value),
    };
    pushService = {
      sendToDevice: jest.fn(),
      sendToTag: jest.fn(),
      sendToAll: jest.fn().mockResolvedValue({ success: true, msgId: 'm1' }),
    };

    const moduleRef = await Test.createTestingModule({
      providers: [
        NotificationDispatcherService,
        {
          provide: getRepositoryToken(Notification),
          useValue: notifRepo,
        },
        {
          provide: getRepositoryToken(User),
          useValue: userRepo,
        },
        {
          provide: PushService,
          useValue: pushService,
        },
        {
          provide: EmailService,
          useValue: {
            send: jest.fn(),
          },
        },
      ],
    }).compile();

    service = moduleRef.get(NotificationDispatcherService);
  });

  it('broadcasts to users matched by admin filters', async () => {
    const qb = {
      andWhere: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([{ id: 'u1' }, { id: 'u2' }]),
    };
    userRepo.createQueryBuilder.mockReturnValue(qb);
    const dispatchSpy = jest
      .spyOn(service, 'dispatch')
      .mockResolvedValue({ id: 'n1' } as any);

    const result = await service.broadcastByFilter({
      titleEn: 'Update',
      titleZh: '更新',
      bodyEn: 'Body',
      bodyZh: '内容',
      type: NotificationType.SYSTEM,
      role: UserRole.SPEAKER,
      isActive: true,
      search: 'alice',
      sendPush: true,
      sendEmail: false,
    });

    expect(qb.andWhere).toHaveBeenCalledWith('user.role = :role', {
      role: UserRole.SPEAKER,
    });
    expect(qb.andWhere).toHaveBeenCalledWith('user.is_active = :isActive', {
      isActive: true,
    });
    expect(dispatchSpy).toHaveBeenCalledTimes(2);
    expect(result).toEqual({
      sent: 2,
      filters: {
        userIds: 0,
        role: UserRole.SPEAKER,
        isActive: true,
        search: 'alice',
      },
    });
  });

  it('broadcasts to event subscribers without tag-only push', async () => {
    const qb = {
      innerJoin: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue([{ id: 'u1' }, { id: 'u2' }]),
    };
    userRepo.createQueryBuilder.mockReturnValue(qb);
    const dispatchSpy = jest
      .spyOn(service, 'dispatch')
      .mockResolvedValue({ id: 'n1' } as any);

    const result = await service.broadcastToEvent({
      eventId: 'e1',
      titleEn: 'Event',
      titleZh: '会议',
      bodyEn: 'Updated',
      bodyZh: '已更新',
      type: NotificationType.EVENT_UPDATE,
      sendPush: true,
      sendEmail: false,
    });

    expect(qb.innerJoin).toHaveBeenCalledWith(
      'u.subscribedEvents',
      'e',
      'e.id = :eventId',
      { eventId: 'e1' },
    );
    expect(dispatchSpy).toHaveBeenCalledTimes(2);
    expect(dispatchSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        userId: 'u1',
        eventId: 'e1',
        sendPush: true,
      }),
    );
    expect(pushService.sendToTag).not.toHaveBeenCalled();
    expect(result).toEqual({ sent: 2, eventId: 'e1' });
  });

  it('broadcasts to all active users through per-user dispatch', async () => {
    userRepo.find.mockResolvedValue([{ id: 'u1' }, { id: 'u2' }]);
    const dispatchSpy = jest
      .spyOn(service, 'dispatch')
      .mockResolvedValue({ id: 'n1' } as any);

    const result = await service.broadcastToAll({
      titleEn: 'Test',
      titleZh: '测试',
      bodyEn: 'Body',
      bodyZh: '内容',
      type: NotificationType.SYSTEM,
      sendPush: true,
      sendEmail: false,
    });

    expect(userRepo.find).toHaveBeenCalledWith({ where: { isActive: true } });
    expect(dispatchSpy).toHaveBeenCalledTimes(2);
    expect(dispatchSpy).toHaveBeenCalledWith(
      expect.objectContaining({ userId: 'u1', sendPush: true }),
    );
    expect(pushService.sendToAll).not.toHaveBeenCalled();
    expect(result).toEqual({
      sent: 2,
      push: { mode: 'per_user', recipients: 2 },
    });
  });
});
