import * as admin from 'firebase-admin';
import { onCall } from 'firebase-functions/https';
import { DatabaseEncoder } from '../common/database';

if (admin.apps.length === 0) {
    admin.initializeApp();
}

export enum RateLimiter {
    SignIn = 'sign_in',
    SignUp = 'sign_up',
    NewDeviceDetectedVerify = 'new_device_detected_verify',
    NewDeviceOtpRequest = 'new_device_otp_request',
    ResetPassword = 'reset_password',
}

type RateLimitConfig = {
    limit: number;
    windowMs: number;
    blockMs?: number;
};

type RateLimitState = {
    count: number;
    resetAt: number;
    lockUntil?: number;
};

type RateLimitResult = {
    limited: boolean;
    resetAt: number;
};

const RATE_LIMIT_CONFIG: Record<RateLimiter, RateLimitConfig> = {
    [RateLimiter.SignIn]: {
        limit: 5,
        windowMs: 5 * 60 * 1000,
        blockMs: 10 * 60 * 1000,
    },
    [RateLimiter.SignUp]: {
        limit: 5,
        windowMs: 24 * 60 * 60 * 1000,
        blockMs: 24 * 60 * 60 * 1000,
    },
    [RateLimiter.NewDeviceDetectedVerify]: {
        limit: 5,
        windowMs: 5 * 60 * 1000,
        blockMs: 10 * 60 * 1000,
    },
    [RateLimiter.NewDeviceOtpRequest]: {
        limit: 5,
        windowMs: 5 * 60 * 1000,
        blockMs: 10 * 60 * 1000,
    },
    [RateLimiter.ResetPassword]: {
        limit: 5,
        windowMs: 10 * 60 * 1000,
        blockMs: 10 * 60 * 1000,
    },
};

function rateLimitRef(rateLimiter: RateLimiter, key: string) {
    return admin
        .database()
        .ref(`/rate_limits/${rateLimiter}/${DatabaseEncoder.encode(key)}`);
}

function now() {
    return Date.now();
}

async function consumeRateLimitInternal(
    rateLimiter: RateLimiter,
    key: string,
): Promise<RateLimitResult> {
    const config = RATE_LIMIT_CONFIG[rateLimiter];
    if (!config) return { limited: false, resetAt: 0 };

    const ref = rateLimitRef(rateLimiter, key);
    const currentTime = now();

    let limited = false;
    let resetAt = 0;

    await ref.transaction((current: RateLimitState | null) => {
        if (current?.lockUntil && current.lockUntil > currentTime) {
            limited = true;
            resetAt = current.lockUntil;
            return current;
        }

        if (!current || current.resetAt <= currentTime) {
            limited = false;
            resetAt = currentTime + config.windowMs;

            return {
                count: 1,
                resetAt,
            };
        }

        if (current.count >= config.limit) {
            limited = true;

            const lockUntil =
                config.blockMs != null
                    ? currentTime + config.blockMs
                    : current.resetAt;

            resetAt = lockUntil;

            return {
                ...current,
                lockUntil,
            };
        }

        limited = false;
        resetAt = current.resetAt;

        return {
            ...current,
            count: current.count + 1,
        };
    });

    return { limited, resetAt };
}

export async function peekIsRateLimited(params: {
    rateLimiter: RateLimiter;
    key: string;
}): Promise<boolean> {
    const { rateLimiter, key } = params;
    const config = RATE_LIMIT_CONFIG[rateLimiter];
    if (!config) return false;

    const snapshot = await rateLimitRef(rateLimiter, key).get();
    const current = snapshot.val() as RateLimitState | null;

    if (!current) return false;

    const currentTime = now();

    if (current.lockUntil && current.lockUntil > currentTime) {
        return true;
    }

    if (current.resetAt <= currentTime) {
        return false;
    }

    return current.count >= config.limit;
}

export async function consumeIsRateLimited(params: {
    rateLimiter: RateLimiter;
    key: string;
}): Promise<boolean> {
    const { limited } = await consumeRateLimitInternal(
        params.rateLimiter,
        params.key,
    );
    return limited;
}

export async function consumeRateLimit(params: {
    rateLimiter: RateLimiter;
    key: string;
}): Promise<RateLimitResult> {
    return consumeRateLimitInternal(params.rateLimiter, params.key);
}

export const isRateLimited = onCall(async (request) => {
    const rateLimiter = request.data?.rateLimiter as RateLimiter | undefined;
    const key = request.data?.key as string | undefined;

    if (!rateLimiter || !key) {
        return { limited: false, resetAt: 0 };
    }

    return consumeRateLimitInternal(rateLimiter, key);
});