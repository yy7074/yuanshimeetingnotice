import { PushService } from './push.service';

describe('PushService', () => {
  afterEach(() => {
    jest.resetModules();
    jest.unmock('jpush-async');
  });

  it('initializes JPush when the package exports buildClient directly', async () => {
    const buildClient = jest.fn(() => ({ push: jest.fn() }));
    jest.doMock(
      'jpush-async',
      () => ({
        buildClient,
      }),
      { virtual: true },
    );

    const service = new PushService({
      get: (key: string) => {
        if (key === 'JPUSH_APP_KEY') return 'app-key';
        if (key === 'JPUSH_MASTER_SECRET') return 'secret';
        return undefined;
      },
    } as any);

    await (service as any)._initJPush();

    expect(buildClient).toHaveBeenCalledWith('app-key', 'secret');
    expect(service.isJPushEnabled).toBe(true);
  });

  it('initializes JPush when the package is nested under default', async () => {
    const buildClient = jest.fn(() => ({ push: jest.fn() }));
    jest.doMock(
      'jpush-async',
      () => ({
        default: {
          buildClient,
        },
      }),
      { virtual: true },
    );

    const service = new PushService({
      get: (key: string) => {
        if (key === 'JPUSH_APP_KEY') return 'app-key';
        if (key === 'JPUSH_MASTER_SECRET') return 'secret';
        return undefined;
      },
    } as any);

    await (service as any)._initJPush();

    expect(buildClient).toHaveBeenCalledWith('app-key', 'secret');
    expect(service.isJPushEnabled).toBe(true);
  });

  it('initializes JPush when the package exports JPushAsync', async () => {
    const buildClient = jest.fn(() => ({ push: jest.fn() }));
    jest.doMock(
      'jpush-async',
      () => ({
        JPushAsync: {
          buildClient,
        },
      }),
      { virtual: true },
    );

    const service = new PushService({
      get: (key: string) => {
        if (key === 'JPUSH_APP_KEY') return 'app-key';
        if (key === 'JPUSH_MASTER_SECRET') return 'secret';
        return undefined;
      },
    } as any);

    await (service as any)._initJPush();

    expect(buildClient).toHaveBeenCalledWith('app-key', 'secret');
    expect(service.isJPushEnabled).toBe(true);
  });
});
