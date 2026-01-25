"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const common_1 = require("@nestjs/common");
const passport_1 = require("@nestjs/passport");
const auth_service_1 = require("./auth.service");
const decorators_1 = require("./decorators");
const role_protected_decorator_1 = require("./decorators/role-protected.decorator");
const dto_1 = require("./dto");
const user_role_guard_1 = require("./guards/user-role.guard");
const interfaces_1 = require("./interfaces");
let AuthController = class AuthController {
    constructor(authService) {
        this.authService = authService;
    }
    async createUser(createUserDto, res) {
        const data = await this.authService.create(createUserDto);
        this.setRefreshTokenCookie(res, data.token);
        return data;
    }
    async loginUser(loginUserDto, res) {
        const data = await this.authService.login(loginUserDto);
        if (data.refreshToken) {
            this.setRefreshTokenCookie(res, data.refreshToken, loginUserDto.remember);
            delete data.refreshToken;
        }
        return data;
    }
    async refreshAuth(req, res) {
        const refreshToken = req.cookies['refreshToken'];
        if (!refreshToken)
            throw new common_1.UnauthorizedException('No valid Refresh Token found');
        const data = await this.authService.refreshAuth(refreshToken);
        this.setRefreshTokenCookie(res, data.refreshToken, true);
        delete data.refreshToken;
        return data;
    }
    logout(res) {
        res.cookie('refreshToken', '', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
            expires: new Date(0)
        });
        return { ok: true };
    }
    setRefreshTokenCookie(res, token, remember = false) {
        const cookieOptions = {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
        };
        if (remember) {
            cookieOptions.expires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
        }
        res.cookie('refreshToken', token, cookieOptions);
    }
    forgotPassword(forgotPasswordDto) {
        return this.authService.forgotPassword(forgotPasswordDto.email);
    }
    validateResetToken(token) {
        return this.authService.validateResetToken(token);
    }
    resetPassword(resetPasswordDto) {
        return this.authService.resetPassword(resetPasswordDto);
    }
    checkAuthStatus(user) {
        return this.authService.checkAuthStatus(user);
    }
    testingPrivateRoute(request, user, userEmail, rawHeaders, headers) {
        return {
            ok: true,
            message: 'Hola Mundo Private',
            user,
            userEmail,
            rawHeaders,
            headers
        };
    }
    privateRoute2(user) {
        return {
            ok: true,
            user
        };
    }
    privateRoute3(user) {
        return {
            ok: true,
            user
        };
    }
};
exports.AuthController = AuthController;
__decorate([
    (0, common_1.Post)('register'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Res)({ passthrough: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.CreateUserDto, Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "createUser", null);
__decorate([
    (0, common_1.Post)('login'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Res)({ passthrough: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.LoginUserDto, Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "loginUser", null);
__decorate([
    (0, common_1.Get)('refresh'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Res)({ passthrough: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "refreshAuth", null);
__decorate([
    (0, common_1.Post)('logout'),
    __param(0, (0, common_1.Res)({ passthrough: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "logout", null);
__decorate([
    (0, common_1.Post)('forgot-password'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.ForgotPasswordDto]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "forgotPassword", null);
__decorate([
    (0, common_1.Get)('reset-password/:token'),
    __param(0, (0, common_1.Param)('token')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "validateResetToken", null);
__decorate([
    (0, common_1.Post)('reset-password'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [dto_1.ResetPasswordDto]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "resetPassword", null);
__decorate([
    (0, common_1.Get)('check-status'),
    (0, decorators_1.Auth)(),
    __param(0, (0, decorators_1.GetUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "checkAuthStatus", null);
__decorate([
    (0, common_1.Get)('private'),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)()),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, decorators_1.GetUser)()),
    __param(2, (0, decorators_1.GetUser)('email')),
    __param(3, (0, decorators_1.RawHeaders)()),
    __param(4, (0, common_1.Headers)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, String, Array, Object]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "testingPrivateRoute", null);
__decorate([
    (0, common_1.Get)('private2'),
    (0, role_protected_decorator_1.RoleProtected)(interfaces_1.ValidRoles.admin),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)(), user_role_guard_1.UserRoleGuard),
    __param(0, (0, decorators_1.GetUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "privateRoute2", null);
__decorate([
    (0, common_1.Get)('private3'),
    (0, decorators_1.Auth)(interfaces_1.ValidRoles.admin),
    __param(0, (0, decorators_1.GetUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], AuthController.prototype, "privateRoute3", null);
exports.AuthController = AuthController = __decorate([
    (0, common_1.Controller)('auth'),
    __metadata("design:paramtypes", [auth_service_1.AuthService])
], AuthController);
//# sourceMappingURL=auth.controller.js.map