package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户表 Mapper。
 *
 * <p>继承 {@link BaseMapper} 即自带单表增删改查，无需写 XML。</p>
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
}
