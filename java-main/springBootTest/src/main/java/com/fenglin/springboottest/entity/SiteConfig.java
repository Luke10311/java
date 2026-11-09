package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

/**
 * 站点配置实体，对应表 {@code meiying_shenbu.site_config}。
 *
 * <p>键值结构：站点名称、副标题、公告、首页主视觉、维护开关等都存这里，
 * 后台「系统设置」直接增改，不用改代码。</p>
 */
@TableName("site_config")
public class SiteConfig {

    @TableId(value = "config_key", type = IdType.INPUT)
    private String configKey;

    private String configValue;

    /** 中文名，后台表单上显示 */
    private String label;

    /** 说明文字 */
    private String remark;

    @TableField(value = "updated_at", insertStrategy = FieldStrategy.NEVER, updateStrategy = FieldStrategy.NEVER)
    private LocalDateTime updatedAt;

    public String getConfigKey() {
        return configKey;
    }

    public void setConfigKey(String configKey) {
        this.configKey = configKey;
    }

    public String getConfigValue() {
        return configValue;
    }

    public void setConfigValue(String configValue) {
        this.configValue = configValue;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
