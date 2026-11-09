package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.Drama;
import org.apache.ibatis.annotations.Mapper;

/** 剧集表 Mapper：继承 BaseMapper 即自带单表增删改查。 */
@Mapper
public interface DramaMapper extends BaseMapper<Drama> {
}
