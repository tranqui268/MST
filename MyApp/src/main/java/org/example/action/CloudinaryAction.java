package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.CloudinaryService;

import java.io.File;

public class CloudinaryAction extends ActionSupport {
    private boolean success;
    private String url;
    private File file;
    private CloudinaryService cloudinaryService;

    public CloudinaryAction(){
        cloudinaryService = new CloudinaryService();
    }

    public String upload() throws Exception {
        url = cloudinaryService.uploadImage(file);
        if (!url.isEmpty()) success = true;
        else success = false;
        return NONE;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }
}
