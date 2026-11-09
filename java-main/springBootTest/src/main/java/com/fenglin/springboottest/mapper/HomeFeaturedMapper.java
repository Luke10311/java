package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.HomeFeatured;
import org.apache.ibatis.annotations.Mapper;

/** 首页精选一案 Mapper。 */
@Mapper
public interface HomeFeaturedMapper extends BaseMapper<HomeFeatured> {
}
