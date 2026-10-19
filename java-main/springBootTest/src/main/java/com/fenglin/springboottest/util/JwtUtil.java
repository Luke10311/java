package com.fenglin.springboottest.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT 工具：签发与解析登录令牌（HS256）。
 *
 * <p>密钥与有效期来自配置：{@code myss.jwt.secret} / {@code myss.jwt.expire-hours}。
 * HS256 要求密钥长度不少于 32 字节（256 位），否则 jjwt 会直接抛异常。</p>
 */
@Component
public class JwtUtil {

    private final SecretKey key;
    private final long expireMillis;

    public JwtUtil(@Value("${myss.jwt.secret}") String secret,
                   @Value("${myss.jwt.expire-hours:24}") long expireHours) {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalStateException("myss.jwt.secret 至少需要 32 个字节（当前 " + keyBytes.length + "）");
        }
        this.key = Keys.hmacShaKeyFor(keyBytes);
        this.expireMillis = expireHours * 60 * 60 * 1000L;
    }

    /** 为指定用户名签发 token */
    public String generate(String username) {
        Date now = new Date();
        return Jwts.builder()
                .subject(username)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expireMillis))
                .signWith(key)
                .compact();
    }

    /**
     * 解析 token 并取出用户名。
     *
     * @return 用户名；token 非法、被篡改或已过期时返回 {@code null}
     */
    public String parseUsername(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            return claims.getSubject();
        } catch (JwtException | IllegalArgumentException e) {
            // 过期 / 签名不符 / 格式错误，一律视为未登录
            return null;
        }
    }
}
