<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết sản phẩm</title>
    <!-- Bootstrap 4 CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
</head>
<body>
    <div class="container mt-3">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="searchProduct.action">Sản phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page">Chi tiết sản phẩm</li>
            </ol>
        </nav>
        <h2>Chi tiết sản phẩm</h2>
        <form id="productForm" enctype="multipart/form-data">
            <div class="row">
                <!-- Cột trái: Các trường nhập liệu -->
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="productName">Tên sản phẩm</label>
                        <input type="text" id="productName" name="productName" class="form-control" required>
                        <div class="invalid-feedback">Tên sản phẩm không được để trống.</div>
                    </div>
                    <div class="form-group">
                        <label for="productPrice">Giá bán</label>
                        <input type="number" id="productPrice" name="productPrice" class="form-control" min="0" step="0.01" required>
                        <div class="invalid-feedback">Giá bán không được nhỏ hơn 0.</div>
                    </div>
                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea id="description" name="description" class="form-control" rows="3"></textarea>
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
                            <button type="button" id="removeFileBtn" title="Xóa file"><i class="bi bi-x"></i></button>
                        </div>
                        <label for="imageUpload" class="custom-file-upload">
                            <i class="bi bi-upload"></i> Upload
                        </label>
                        <input type="file" id="imageUpload" name="imageUpload" accept="image/png,image/jpeg">
                        <div id="uploadResult"></div>
                    </div>
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

    <!-- jQuery, Popper.js, Bootstrap 4 JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        $(document).ready(function () {
            // Hiển thị ảnh xem trước
            $('#imageUpload').on('change', function () {
                const file = this.files[0];
                const $uploadResult = $('#uploadResult');
                const $imagePreview = $('#imagePreview');
                const $imagePreviewContainer = $('#imagePreviewContainer');

                if (!file) {
                    $uploadResult.html('<p class="text-danger">Vui lòng chọn file ảnh.</p>');
                    $imagePreviewContainer.hide();
                    return;
                }

                // Kiểm tra định dạng
                const allowedTypes = ['image/png', 'image/jpeg'];
                if (!allowedTypes.includes(file.type)) {
                    $uploadResult.html('<p class="text-danger">Chỉ chấp nhận file PNG, JPG, JPEG.</p>');
                    $imagePreviewContainer.hide();
                    return;
                }

                // Kiểm tra dung lượng (2MB)
                const maxSize = 2 * 1024 * 1024; // 2MB in bytes
                if (file.size > maxSize) {
                    $uploadResult.html('<p class="text-danger">Dung lượng file không được vượt quá 2MB.</p>');
                    $imagePreviewContainer.hide();
                    return;
                }

                // Kiểm tra kích thước ảnh
                const img = new Image();
                img.onload = function () {
                    if (this.width > 1024 || this.height > 1024) {
                        $uploadResult.html('<p class="text-danger">Kích thước ảnh không được vượt quá 1024px.</p>');
                        $imagePreviewContainer.hide();
                    } else {
                        $uploadResult.html('');
                        $imagePreview.attr('src', this.src);
                        $imagePreviewContainer.show();
                    }
                };
                img.onerror = function () {
                    $uploadResult.html('<p class="text-danger">File không phải là ảnh hợp lệ.</p>');
                    $imagePreviewContainer.hide();
                };
                img.src = URL.createObjectURL(file);
            });

            // Xử lý nút "Xóa file"
            $('#removeFileBtn').on('click', function () {
                $('#imageUpload').val('');
                $('#imagePreviewContainer').hide();
                $('#uploadResult').html('');
            });

            // Xử lý form submit
            $('#productForm').on('submit', function (e) {
                e.preventDefault();

                // Validation
                let isValid = true;
                const productName = $('#productName').val().trim();
                const productPrice = parseFloat($('#productPrice').val());
                const file = $('#imageUpload')[0].files[0];

                if (!productName) {
                    $('#productName').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#productName').removeClass('is-invalid');
                }

                if (isNaN(productPrice) || productPrice < 0) {
                    $('#productPrice').addClass('is-invalid');
                    isValid = false;
                } else {
                    $('#productPrice').removeClass('is-invalid');
                }

                if (!isValid) return;

                // Chuẩn bị dữ liệu gửi đi
                const formData = new FormData();
                formData.append('name', productName);
                formData.append('price', productPrice);
                formData.append('description', $('#description').val());
                formData.append('status', $('#isSales').val());
                if (file) {
                    formData.append('file', file);
                }

                $.ajax({
                    url: 'addProduct',
                    method: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        if (response.success) {
                            alert('Lưu sản phẩm thành công!');
                            window.location.href = 'searchProduct.action';
                        } else {
                            alert('Lưu sản phẩm thất bại: ' + (response.message || 'Lỗi không xác định'));
                        }
                    },
                    error: function (xhr, status, error) {
                        alert('Lỗi khi lưu sản phẩm: ' + error);
                    }
                });
            });

            // Xử lý nút Hủy
            $('#cancelBtn').on('click', function () {
                window.location.href = 'searchProduct.action';
            });
        });
    </script>
</body>
</html>