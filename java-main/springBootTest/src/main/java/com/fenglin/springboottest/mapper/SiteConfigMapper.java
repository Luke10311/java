package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.SiteConfig;
import org.apache.ibatis.annotations.Mapper;

/** 站点配置表 Mapper。 */
@Mapper
public interface SiteConfigMapper extends BaseMapper<SiteConfig> {
}
