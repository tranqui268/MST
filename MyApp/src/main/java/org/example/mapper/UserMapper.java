package org.example.mapper;

import org.apache.ibatis.annotations.Param;
import org.example.model.User;

import java.util.List;
import java.util.Map;
import java.util.Objects;

public interface UserMapper {
    User findByUsernameAndPassword(@Param("email") String email, @Param("password") String password);
    int updateLastLogin(int id);
    int updateRememberToken(@Param("id") int id, @Param("token") String token);
    User findByRememberToken(@Param("token") String token);
    int updateLastIp(@Param("id") int id, @Param("ip") String ip);

    List<User> getAllUser();
    int countFilteredUsers(Map<String, Object> filter);
    List<User> getFilteredUsers(Map<String, Object> filter);
    int updateUserStatus(@Param("id") int id, @Param("is_active") int is_active);

    User getUserByEmail(@Param("id") int id, @Param("email") String email);

    User findUserByEmail(@Param("email") String email);

    int addUser(@Param("name") String name, @Param("email") String email,@Param("password") String password, @Param("groupRole") String groupRole);

    int deleteUser(@Param("id")int id);

    int updateUser(@Param("id")int id, @Param("name") String name, @Param("email") String email, @Param("password") String password,@Param("groupRole") String groupRole );

    int deleteUsersBulk(@Param("ids") List<Integer> ids);
}
