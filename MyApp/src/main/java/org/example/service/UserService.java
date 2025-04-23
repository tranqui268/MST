package org.example.service;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.example.mapper.UserMapper;
import org.example.model.User;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserService {
    private SqlSessionFactory sqlSessionFactory;

    public UserService() throws Exception{
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    }

    public User authenticate(String email, String password){
        System.out.println("POST request - Processing login");
        System.out.println("Username: " + email + ", Password: " + password);
        try(SqlSession session = sqlSessionFactory.openSession()){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.findByUsernameAndPassword(email, password);

        }
    }

    public int updateLastLogin(int id){
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.updateLastLogin(id);
        }
    }

    public int updateRememberToken(int id, String token){
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.updateRememberToken(id, token);
        }
    }

    public int updateLastIp(int id, String ip){
        try(SqlSession session = sqlSessionFactory.openSession(true)){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return  mapper.updateLastIp(id, ip);
        }
    }

    public User findByRememberToken(String token){
        try(SqlSession session = sqlSessionFactory.openSession()){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.findByRememberToken(token);

        }
    }

    public List<User> getAllUser(){
        try(SqlSession session = sqlSessionFactory.openSession()){
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.getAllUser();

        }
    }

    public List<User> getUsersWithPagination(String name, String email, String group, String status, int page, int pageSize) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            UserMapper mapper = session.getMapper(UserMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("email", email);
            params.put("group", group);
            params.put("status", status);
            params.put("offset", (page - 1) * pageSize);
            params.put("pageSize", pageSize);
            System.out.println("FETCHDATA:" +mapper.getFilteredUsers(params));
            return mapper.getFilteredUsers(params);
        }

    }

    public int countUsers(String name, String email, String group, String status) {
        try(SqlSession session = sqlSessionFactory.openSession()){
            UserMapper mapper = session.getMapper(UserMapper.class);
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            params.put("email", email);
            params.put("group", group);
            params.put("status", status);
            return mapper.countFilteredUsers(params);
        }

    }


    public int updateIsActive(int id , int isActive){
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.updateUserStatus(id, isActive);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    public User getUserByEmail(int id,String email){
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.getUserByEmail(id,email);
        }
    }

    public int addUser(String name, String email,String password, String groupRole){
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.addUser(name, email, password, groupRole);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }

    }

    public int deleteUser(int id){
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.deleteUser(id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    public int updateUser(int id, String name, String email, String password, String groupRole){
        try (SqlSession session = sqlSessionFactory.openSession(true)) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.updateUser(id, name, email, password, groupRole);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }



}
