package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.CaseFile;
import org.apache.ibatis.annotations.Mapper;

/** 案卷表 Mapper。 */
@Mapper
public interface CaseFileMapper extends BaseMapper<CaseFile> {
}
