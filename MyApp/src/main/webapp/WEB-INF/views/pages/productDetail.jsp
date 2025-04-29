<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

            <style>
                #imagePreviewContainer {
                    display: none;
                    position: relative;
                    margin-top: 10px;
                }

                #imagePreview {
                    max-width: 150px;
                    max-height: 150px;
                }

                #removeFileBtn {
                    position: absolute;
                    top: 0;
                    right: 0;
                    background: white;
                    border: 1px solid #ccc;
                    padding: 2px 5px;
                    cursor: pointer;
                    color: blue;
                }

                .custom-file-upload {
                    display: inline-block;
                    padding: 6px 12px;
                    cursor: pointer;
                    background-color: #007bff;
                    color: white;
                    border-radius: 4px;
                }

                .custom-file-upload:hover {
                    background-color: #0056b3;
                }

                #imageUpload {
                    display: none;
                }
            </style>

            <div class="container mt-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="product.action">Sản phẩm</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Chi tiết sản phẩm</li>
                    </ol>
                </nav>
                <h2>Chi tiết sản phẩm</h2>
                <form id="productForm" enctype="multipart/form-data">
                    <s:if test="product != null">
                        <input type="hidden" id="productId" name="productId"
                            value="<s:property value='product.product_id' default=""/>" />

                    </s:if>
                    <div class="row">

                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="productName">Tên sản phẩm</label>
                                <input type="text" id="productName" name="productName" class="form-control" required>
                                <div class="invalid-feedback">Tên sản phẩm không được để trống.</div>
                            </div>
                            <div class="form-group">
                                <label for="productPrice">Giá bán</label>
                                <input type="number" id="productPrice" name="productPrice" class="form-control" min="0"
                                    step="0.01" required>
                                <div class="invalid-feedback">Giá bán không được nhỏ hơn 0.</div>
                            </div>
                            <div class="form-group">
                                <label for="description">Mô tả</label>
                                <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                                <div class="invalid-feedback">Mô tả không hợp lệ.</div>
                            </div>
                            <div class="form-group">
                                <label for="isSales">Trạng thái</label>
                                <select id="isSales" name="isSales" class="form-control">
                                    <option value="1">Đang bán</option>
                                    <option value="0">Ngừng bán</option>
                                </select>
                            </div>
                        </div>

                        <!-- Cột phải: Phần hình ảnh -->
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Hình ảnh</label>
                                <div id="imagePreviewContainer">
                                    <img id="imagePreview" src="#" alt="Xem trước ảnh">
                                    <button type="button" id="removeFileBtn" title="Xóa file"><i
                                            class="bi bi-x"></i></button>
                                </div>
                                <label for="imageUpload" class="custom-file-upload">
                                    <i class="bi bi-upload"></i> Upload
                                </label>
                                <input type="file" id="imageUpload" name="imageUpload" accept="image/png,image/jpeg">
                                <div id="uploadResult"></div>
                            </div>
                            <input type="hidden" id="oldImageUrl" name="oldImageUrl" value="">

                        </div>
                    </div>

                    <!-- Nút Hủy và Lưu -->
                    <div class="row">
                        <div class="col-md-12">
                            <button type="button" id="cancelBtn" class="btn btn-secondary">Hủy</button>
                            <button type="submit" class="btn btn-danger">Lưu</button>
                        </div>
                    </div>
                </form>
            </div>

