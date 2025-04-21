package org.example.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
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
        BufferedImage image = ImageIO.read(file);
        if (image == null) {
            throw new Exception("File không phải là ảnh hợp lệ.");
        }

        int width = image.getWidth();
        int height = image.getHeight();
        if (width > 1024 || height > 1024) {
            throw new Exception("Kích thước ảnh không được vượt quá 1024px (chiều rộng hoặc chiều cao).");
        }
        Map uploadResult = cloudinary.uploader().upload(file, ObjectUtils.emptyMap());
        return uploadResult.get("url").toString();
    }
}
