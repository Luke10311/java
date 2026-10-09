package com.meiying.shenbu.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 密码散列工具：加盐 SHA-256（演示级方案）
 */
public class PasswordUtil {

    private static final String SALT = "myss::shenbu::2026";

    public static String hash(String rawPassword) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest((SALT + rawPassword).getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 不可用", e);
        }
    }

    /** 校验明文密码与散列是否匹配 */
    public static boolean matches(String rawPassword, String hashed) {
        return hash(rawPassword).equals(hashed);
    }
}
