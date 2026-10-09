package com.meiying.shenbu.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT 工具：登录态令牌签发与解析（有效期 24 小时）
 */
public class JwtUtil {

    private static final String SECRET = "meiying-shenbu-secret-key-2026-!!";
    private static final SecretKey KEY = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    private static final long EXPIRE_MS = 24 * 60 * 60 * 1000L;

    /** 为指定用户名签发 token */
    public static String generate(String username) {
        Date now = new Date();
        return Jwts.builder()
                .subject(username)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + EXPIRE_MS))
                .signWith(KEY)
                .compact();
    }

    /** 解析 token 返回用户名；无效或过期返回 null */
    public static String parse(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(KEY)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            return claims.getSubject();
        } catch (Exception e) {
            return null;
        }
    }
}
