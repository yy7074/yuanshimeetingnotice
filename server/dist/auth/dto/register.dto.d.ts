export declare class RegisterDto {
    email: string;
    password: string;
    nameEn?: string;
    nameZh?: string;
}
export declare class LoginDto {
    email: string;
    password: string;
}
export declare class ForgotPasswordDto {
    email: string;
}
export declare class ResetPasswordDto {
    email: string;
    code: string;
    newPassword: string;
}
