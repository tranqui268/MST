package org.example.action;

import com.opensymphony.xwork2.ActionSupport;
import org.example.service.CustomerService;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class ImportCustomer extends ActionSupport {
    private File file;
    private String fileContentType;
    private String fileFileName;

    private boolean successs;
    private List<String> errors;
    private CustomerService customerService;

    public ImportCustomer() throws Exception {
        customerService = new CustomerService();
    }

    public String importFile(){
        System.out.println("File received: " + file);
        System.out.println("File name: " + fileFileName);
        System.out.println("Content type: " + fileContentType);
        errors = new ArrayList<>();
        if (file == null) {

            errors.add("Không nhận được file Excel.");
            return SUCCESS;
        }
        errors = customerService.importCustomer(file);
        successs = errors.isEmpty();

        return SUCCESS;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getFileContentType() {
        return fileContentType;
    }

    public void setFileContentType(String fileContentType) {
        this.fileContentType = fileContentType;
    }

    public String getFileFileName() {
        return fileFileName;
    }

    public void setFileFileName(String fileFileName) {
        this.fileFileName = fileFileName;
    }

    public boolean isSuccesss() {
        return successs;
    }

    public void setSuccesss(boolean successs) {
        this.successs = successs;
    }

    public List<String> getErrors() {
        return errors;
    }

    public void setErrors(List<String> errors) {
        this.errors = errors;
    }
}
