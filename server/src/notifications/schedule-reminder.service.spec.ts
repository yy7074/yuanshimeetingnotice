import { ScheduleReminderService } from './schedule-reminder.service';
import { NotificationDispatcherService } from './notification-dispatcher.service';
import { Session } from '../sessions/entities/session.entity';
import { User } from '../users/entities/user.entity';

type MockRepo<T> = {
  find: jest.Mock<Promise<T[]>, [unknown?]>;
  createQueryBuilder: jest.Mock;
};

describe('ScheduleReminderService', () => {
  let service: ScheduleReminderService;
  let sessionRepo: MockRepo<Session>;
  let userRepo: MockRepo<User>;
  let dispatcher: jest.Mocked<NotificationDispatcherService>;

  beforeEach(() => {
    sessionRepo = {
      find: jest.fn(),
      createQueryBuilder: jest.fn(),
    };

    userRepo = {
      find: jest.fn(),
      createQueryBuilder: jest.fn(),
    };

    dispatcher = {
      dispatch: jest.fn().mockResolvedValue(undefined),
      sendScheduleReminder: jest.fn().mockResolvedValue(undefined),
    } as unknown as jest.Mocked<NotificationDispatcherService>;

    service = new ScheduleReminderService(
      sessionRepo as never,
      userRepo as never,
      dispatcher,
    );
  });

  it('sends the correct daily session count per event', async () => {
    sessionRepo.find.mockResolvedValue([
      {
        eventId: 'event-1',
        event: { titleEn: 'Summit', titleZh: '峰会' },
      },
      {
        eventId: 'event-1',
        event: { titleEn: 'Summit', titleZh: '峰会' },
      },
    ] as Session[]);

    const subscribers = [{ id: 'user-1' }, { id: 'user-2' }] as User[];
    const queryBuilder = {
      innerJoin: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue(subscribers),
    };
    userRepo.createQueryBuilder.mockReturnValue(queryBuilder);

    await service.handleDailySummary();

    expect(dispatcher.dispatch).toHaveBeenCalledTimes(2);
    expect(dispatcher.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        userId: 'user-1',
        eventId: 'event-1',
        bodyEn: expect.stringContaining('2 sessions'),
        bodyZh: expect.stringContaining('2 场议程'),
      }),
    );
    expect(dispatcher.dispatch).toHaveBeenCalledWith(
      expect.objectContaining({
        userId: 'user-2',
        eventId: 'event-1',
        bodyEn: expect.stringContaining('2 sessions'),
        bodyZh: expect.stringContaining('2 场议程'),
      }),
    );
  });

  it('sends schedule reminders to event subscribers', async () => {
    sessionRepo.find.mockResolvedValue([
      {
        eventId: 'event-1',
        titleEn: 'Opening Keynote',
        titleZh: '开幕主旨演讲',
        roomEn: 'Hall A',
        roomZh: 'A厅',
        event: { id: 'event-1' },
      },
    ] as Session[]);

    const subscribers = [{ id: 'user-1' }] as User[];
    const queryBuilder = {
      innerJoin: jest.fn().mockReturnThis(),
      getMany: jest.fn().mockResolvedValue(subscribers),
    };
    userRepo.createQueryBuilder.mockReturnValue(queryBuilder);

    await service.handleSessionReminders();

    expect(dispatcher.sendScheduleReminder).toHaveBeenCalledTimes(1);
    expect(dispatcher.sendScheduleReminder).toHaveBeenCalledWith(
      'user-1',
      'Opening Keynote',
      '开幕主旨演讲',
      'Hall A',
      'A厅',
    );
  });
});
