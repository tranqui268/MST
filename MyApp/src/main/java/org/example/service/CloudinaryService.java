package org.example.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.security.MessageDigest;
import java.util.Map;

public class CloudinaryService {
    private Cloudinary cloudinary;
    public CloudinaryService(){
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dhis8yzem",
                "api_key", "133792976766817",
                "api_secret", "NLBSR18TL9JMYvHreSXTMOfYUdk"
        ));
    }

    public String uploadImage(File file) throws Exception{
        if (file == null){
            throw new Exception("File đang rỗng");
        }

        BufferedImage image = ImageIO.read(file);
        if (image == null) {
            throw new Exception("File không phải là ảnh hợp lệ.");
        }

        int width = image.getWidth();
        int height = image.getHeight();
        if (width > 1024 || height > 1024) {
            throw new Exception("Kích thước ảnh không được vượt quá 1024px (chiều rộng hoặc chiều cao).");
        }

        String hash = getSHA1(file);
        String publicId = "images/" + hash;

        try{
            Map result = cloudinary.api().resource(publicId, ObjectUtils.emptyMap());
            return result.get("secure_url").toString();
        }catch (Exception e){
            Map uploadResult = cloudinary.uploader().upload(file, ObjectUtils.asMap(
                    "public_id", publicId,
                    "overwrite", false
            ));
            return uploadResult.get("secure_url").toString();
        }
    }

    public String getSHA1(File file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-1");
        FileInputStream fis = new FileInputStream(file);
        byte[] buffer = new byte[1024];
        int numRead;
        while ((numRead = fis.read(buffer)) != -1) {
            digest.update(buffer, 0, numRead);
        }
        fis.close();
        byte[] hashBytes = digest.digest();

        // Convert to hex string
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

}
