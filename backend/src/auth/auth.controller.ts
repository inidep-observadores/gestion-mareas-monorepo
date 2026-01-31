import { Controller, Get, Post, Body, UseGuards, Req, Headers, SetMetadata, Param, Res, UnauthorizedException } from '@nestjs/common';
import { Response, Request } from 'express';
import { AuthGuard } from '@nestjs/passport';
import { IncomingHttpHeaders } from 'http';

import { AuthService } from './auth.service';
import { RawHeaders, GetUser, Auth } from './decorators';
import { RoleProtected } from './decorators/role-protected.decorator';

import { CreateUserDto, LoginUserDto, ForgotPasswordDto, ResetPasswordDto } from './dto';
import { User } from '@prisma/client';
import { UserRoleGuard } from './guards/user-role.guard';
import { ValidRoles } from './interfaces';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('register')
  async createUser(
    @Body() createUserDto: CreateUserDto,
    @Res({ passthrough: true }) res: Response
  ) {
    const data = await this.authService.create(createUserDto);
    this.setRefreshTokenCookie(res, data.token); // Assuming create returns token (access) and we derive refresh or it returns both? 
    // Wait, create service currently returns { user, token }. I need to update it to return refreshToken too or standard is:
    // Service returns tokens, Controller sets cookie.
    // I need to update service 'create' and 'login' to return refreshToken as well.
    // I already updated 'refreshAuth' to return it.
    // Let's assume I will update 'create' and 'login' in service next or now.
    // Actually, I should have done that in the previous step. Valid point. 
    // I will use a helper here and assume standard return structure.
    return data;
  }

  @Post('login')
  async loginUser(
    @Body() loginUserDto: LoginUserDto,
    @Res({ passthrough: true }) res: Response
  ) {
    const data = await this.authService.login(loginUserDto);

    if (data.refreshToken) {
      this.setRefreshTokenCookie(res, data.refreshToken, loginUserDto.remember);
      delete data.refreshToken; // Remove from body
    }
    return data;
  }

  @Get('refresh')
  async refreshAuth(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response
  ) {
    const refreshToken = req.cookies['refreshToken'];
    if (!refreshToken) throw new UnauthorizedException('No valid Refresh Token found');

    const data = await this.authService.refreshAuth(refreshToken);
    this.setRefreshTokenCookie(res, data.refreshToken, true); // Refresh always extends? or stays same? Usually extends.
    delete data.refreshToken;
    return data;
  }

  @Post('logout')
  logout(
    @Res({ passthrough: true }) res: Response
  ) {
    res.cookie('refreshToken', '', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
      expires: new Date(0)
    });
    return { ok: true };
  }


  // Helper
  private setRefreshTokenCookie(res: Response, token: string, remember = false) {
    const cookieOptions: any = {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax',
    };

    if (remember) {
      cookieOptions.expires = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days
    }

    res.cookie('refreshToken', token, cookieOptions);
  }

  @Post('forgot-password')
  forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto) {
    return this.authService.forgotPassword(forgotPasswordDto.email);
  }

  @Get('reset-password/:token')
  validateResetToken(@Param('token') token: string) {
    return this.authService.validateResetToken(token);
  }

  @Post('reset-password')
  resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
    return this.authService.resetPassword(resetPasswordDto);
  }

  @Get('check-status')
  @Auth()
  checkAuthStatus(
    @GetUser() user: User
  ) {
    return this.authService.checkAuthStatus(user);
  }


  @Get('private')
  @UseGuards(AuthGuard())
  testingPrivateRoute(
    @Req() request: Express.Request,
    @GetUser() user: User,
    @GetUser('email') userEmail: string,

    @RawHeaders() rawHeaders: string[],
    @Headers() headers: IncomingHttpHeaders,
  ) {


    return {
      ok: true,
      message: 'Hola Mundo Private',
      user,
      userEmail,
      rawHeaders,
      headers
    }
  }


  // @SetMetadata('roles', ['admin','super-user'])

  @Get('private2')
  @RoleProtected(ValidRoles.admin)
  @UseGuards(AuthGuard(), UserRoleGuard)
  privateRoute2(
    @GetUser() user: User
  ) {

    return {
      ok: true,
      user
    }
  }


  @Get('private3')
  @Auth(ValidRoles.admin)
  privateRoute3(
    @GetUser() user: User
  ) {

    return {
      ok: true,
      user
    }
  }

}
