package org.example.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.example.model.User;

import java.util.Date;

public class JwtUtil {
    private static final String SECRET = "LW9jM2ZrZjctZDU2NC00ODg2LTg5YTUtYjZkZTc0ZTZlZTll";
    private static final long EXPIRATION_TIME = 7 * 24 * 60 * 60 * 1000;

    public static String generateToken(User user){
        return JWT.create()
                .withSubject(user.getEmail())
                .withClaim("userId",user.getId())
                .withClaim("group_role",user.getGroup_role())
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .sign(Algorithm.HMAC256(SECRET));
    }

    public static DecodedJWT verifyToken(String token){
        Algorithm algorithm = Algorithm.HMAC256(SECRET);
        JWTVerifier jwtVerifier = JWT.require(algorithm).build();
        return jwtVerifier.verify(token);
    }

    public static String getGroupRole(String token) {
        DecodedJWT jwt = verifyToken(token);
        return jwt.getClaim("group_role").asString();
    }

}
