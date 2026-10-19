package com.fenglin.springboottest.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 密码散列工具：加盐 SHA-256。
 *
 * <p>注意：这是教学/演示级方案。生产环境请改用 BCrypt、Argon2 等带工作因子的算法。</p>
 */
public final class PasswordUtil {

    /** 固定盐值；若要更安全，应为每个用户生成独立随机盐并存入表中 */
    private static final String SALT = "myss::shenbu::2026";

    private PasswordUtil() {
    }

    /** 把明文密码转成 64 位十六进制散列串 */
    public static String hash(String rawPassword) {
        if (rawPassword == null) {
            throw new IllegalArgumentException("密码不可为 null");
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest((SALT + rawPassword).getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(digest.length * 2);
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("当前 JVM 不支持 SHA-256", e);
        }
    }

    /** 校验明文密码与库中散列是否匹配 */
    public static boolean matches(String rawPassword, String hashed) {
        if (rawPassword == null || hashed == null) {
            return false;
        }
        return hash(rawPassword).equals(hashed);
    }
}
