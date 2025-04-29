            <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
            <%@ taglib prefix="s" uri="/struts-tags" %>
            <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
 <script>
                        if (typeof jQuery === 'undefined') {
                            console.error('jQuery is not loaded!');
                        } else {
                            console.log('jQuery loaded successfully:', jQuery.fn.jquery);
                            if (typeof $.ajax === 'undefined') {
                                console.error('$.ajax is not available! Make sure to use the full jQuery version.');
                            } else {
                                console.log('$.ajax is available');
                            }
                        }

                        $(document).ready(function () {

                            console.log('Document ready - Starting AJAX call');

                            loadCustomer(1);
                            // fetch data user
                            function loadCustomer(page = 1) {
                                let searchParams = {
                                    name: $('#searchName').val() ?? '',
                                    email: $('#searchEmail').val() ?? '',
                                    status: $('#searchStatus').val() ?? '',
                                    address: $('#searchAddress').val() ?? ''
                                };
                                console.log('loadUser function called for page:', page);
                                $.ajax({
                                    url: 'getFilteredCustomer',
                                    type: 'GET',
                                    data: {
                                        name: searchParams.name,
                                        email: searchParams.email,
                                        status: searchParams.status,
                                        address: searchParams.address,
                                        page: page
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        console.log('Response:', response);
                                        let tableBody = $('#customerTableBody');
                                        tableBody.empty();


                                        // Hiển thị danh sách user
                                        if (response.data && response.data.length > 0) {
                                            console.log('Response:', response);
                                            const startIndex = (page - 1) * response.paginationInfo.pageSize;
                                            $.each(response.data, function (index, customer) {
                                                let row = '<tr>' +
                                                    '<td>' + (startIndex + index + 1) + '</td>' +
                                                    '<td>' + customer.customer_name + '</td>' +
                                                    '<td>' + customer.email + '</td>' +
                                                    '<td>' + (customer.address) + '</td>' +
                                                    '<td>' + (customer.tel_num) + '</td>' +
                                                    '<td>' +
                                                    '<a class="editUser text-info mr-2" data-id="' + customer.customer_id + '"><i class="bi bi-pencil-fill" style="color: blue"></i></a>' +
                                                    '</td>' +
                                                    '</tr>';
                                                tableBody.append(row);
                                            });

                                            $('#total').html('<p>Hiển thị từ ' + (startIndex + 1) + ' ~ ' + (startIndex + response.data.length) + ' trong tổng số ' + response.paginationInfo.totalCustomers + ' khách hàng</p>');


                                        } else {
                                            tableBody.append('<tr><td colspan="5" class="text-center">Không có dữ liệu</td></tr>');
                                        }

                                        // Hiển thị phân trang
                                        let pagination = $('#pagination');
                                        pagination.empty();
                                        let paginationInfo = response.paginationInfo;
                                        let currentPage = paginationInfo.currentPage;
                                        let totalPages = paginationInfo.totalPages;

                                        // Nút Previous
                                        if (totalPages > 1) {
                                            if (currentPage > 1) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Previous</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>');
                                            }

                                            // Các số trang
                                            for (let i = 1; i <= totalPages; i++) {
                                                if (i === currentPage) {
                                                    pagination.append('<li class="page-item active"><a class="page-link" href="#">' + i + '</a></li>');
                                                } else {
                                                    pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
                                                }
                                            }

                                            // Nút Next
                                            if (currentPage < totalPages) {
                                                pagination.append('<li class="page-item"><a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Next</a></li>');
                                            } else {
                                                pagination.append('<li class="page-item disabled"><a class="page-link" href="#">Next</a></li>');
                                            }

                                            // Gắn sự kiện cho các nút phân trang
                                            $('.page-link').click(function (e) {
                                                e.preventDefault();
                                                let page = $(this).data('page');
                                                if (page) {
                                                    loadCustomer(page);
                                                }
                                            });
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        console.error('Error fetching users:', error);
                                        console.error('Status:', status);
                                        console.error('XHR:', xhr);
                                        $('#userTableBody').html('<tr><td colspan="5" class="text-center text-danger">Lỗi khi tải dữ liệu</td></tr>');
                                    }
                                });
                            }

                            // event search
                            $('#searchForm').on('submit', function (e) {
                                e.preventDefault();
                                loadCustomer(1);
                            });

                            $('#clearSearchBtn').click(function (e) {
                                e.preventDefault();


                                $('#searchName').val('');
                                $('#searchEmail').val('');
                                $('#searchAddress').val('');
                                $('#searchStatus').val('');


                                loadCustomer(1);
                            });




                            //Validate add user
                            $('#btnAdd').on('click', function () {
                                $('#addCustomerForm')[0].reset();
                                $('#addCustomerModalLabel').text('Thêm khách hàng');

                                $('#addCustomerModal').modal('show');
                            });



                            $('#addCustomerModal').on('show.bs.modal', function () {

                                const errorIds = ['#nameError', '#emailError', '#phoneError', '#addressError'];
                                errorIds.forEach(id => $(id).text(''));
                            });


                            $('#saveCustomerBtn').on('click', function () {
                                let name = $('#newName').val().trim();
                                let email = $('#newEmail').val().trim();
                                let phone = $('#newPhone').val().trim();
                                let address = $('#newAddress').val().trim();

                                const errorIds = ['#nameError', '#emailError', '#phoneError', '#addressError'];
                                errorIds.forEach(id => $(id).text(''));

                                let specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
                                let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                                const phoneRegex = /^0\d{9}$/;
                                let hasError = false;

                                if (!name) {
                                    $('#nameError').text('Tên không được để trống');
                                    hasError = true;
                                } else if (specialCharRegex.test(name)) {
                                    $('#nameError').text('Tên không được chứa ký tự đặc biệt');
                                    hasError = true;
                                }

                                if (!email) {
                                    $('#emailError').text('Email không được để trống.');
                                    hasError = true;
                                } else if (!emailRegex.test(email)) {
                                    $('#emailError').text('Email không đúng định dạng.');
                                    hasError = true;
                                } else if (specialCharRegex.test(email.split('@')[0])) {
                                    $('#emailError').text('Phần trước @ của email không được chứa ký tự đặc biệt.');
                                    hasError = true;
                                }

                                if (!phone) {
                                    $('#phoneError').text('Điện thoại không được để trống');
                                    hasError = true;
                                } else if (phoneRegex.test(phone)) {
                                    $('#phoneError').text('Điện thoại không đúng định dạng');
                                    hasError = true;
                                }

                                if (!address) {
                                    $('#addressError').text('Địa chỉ không được để trống');
                                    hasError = true;
                                }


                                if (hasError) return;

                                $.ajax({
                                    url: 'checkCustomerExist',
                                    method: 'POST',
                                    data: {
                                        customer_id: 0,
                                        email: email
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        if (response.success) {
                                            $('#emailError').text('Email đã tồn tại.');
                                        } else {

                                            $.ajax({
                                                url: 'addCustomer',
                                                method: 'POST',
                                                data: {
                                                    name: name,
                                                    email: email,
                                                    tel_num: phone,
                                                    address: address
                                                },
                                                dataType: 'json',
                                                success: function (response) {
                                                    if (response.success) {
                                                        alert("Thêm thành công");
                                                        $('#addCustomerForm')[0].reset();
                                                        loadCustomer();
                                                    } else {
                                                        alert("Thêm thất bại");
                                                    }
                                                    $('#addCustomerModal').modal('hide');
                                                },
                                                error: function () {
                                                    alert("Lỗi khi thêm");
                                                    $('#addCustomerModal').modal('hide');
                                                }

                                            });
                                        }
                                    }

                                });
                            });


                            // edit customer
                            $(document).on('click', '.editUser', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');
                                console.log(id);


                                const name = row.find('td:eq(1)').text().trim();
                                const email = row.find('td:eq(2)').text().trim();
                                const address = row.find('td:eq(3)').text().trim();
                                const tel = row.find('td:eq(4)').text().trim();

                                // Chuyển các ô sang input
                                row.find('td:eq(1)').html('<input type="text" class="form-control form-control-sm edit-name" value="' + name + '">');
                                row.find('td:eq(2)').html('<input type="email" class="form-control form-control-sm edit-email" value="' + email + '">');
                                row.find('td:eq(3)').html('<input type="text" class="form-control form-control-sm edit-address" value="' + address + '">');
                                row.find('td:eq(4)').html('<input type="text" class="form-control form-control-sm edit-tel" value="' + tel + '">');

                                // Thay nút "Edit" bằng "Save" và "Cancel"
                                row.find('td:eq(5)').html('<a href="#" class="saveEdit text-success mr-2" data-id="' + id + '"><i class="bi bi-check-lg"></i></a>' +
                                    '<a href="#" class="cancelEdit text-secondary" data-id="' + id + '"><i class="bi bi-x-lg"></i></a>');
                            });

                            // save edit
                            $(document).on('click', '.saveEdit', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');
                                let specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;
                                console.log(id);


                                var name = row.find('.edit-name').val().trim();
                                var email = row.find('.edit-email').val().trim();
                                var address = row.find('.edit-address').val().trim();
                                var tel = row.find('.edit-tel').val().trim();

                                // Validation
                                if (name === '' || email === '' || tel === '') {
                                    alert('Vui lòng điền đầy đủ tên, email và số điện thoại!');
                                    return;
                                }

                                if (specialCharRegex.test(name)){
                                    alert('Tên không hợp lệ!');
                                    return;
                                }

                                const phoneRegex = /^0\d{9}$/;
                                if (!phoneRegex.test(tel)) {
                                    alert('Số điện thoại không hợp lệ!');
                                    return;
                                }

                                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                if (!emailRegex.test(email)) {
                                    alert('Email không đúng định dạng!');
                                    return;
                                }

                                // Gửi request cập nhật
                                $.ajax({
                                    url: 'checkCustomerExist',
                                    method: 'POST',
                                    data: {
                                        customer_id: id,
                                        email: email
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        if (response.success) {
                                            alert("email đã tồn tại");
                                        } else {
                                            $.ajax({
                                                url: 'updateCustomer',
                                                type: 'POST',
                                                data: {
                                                    customer_id: id,
                                                    name: name,
                                                    email: email,
                                                    tel_num: tel,
                                                    address: address,

                                                },
                                                success: function (response) {
                                                    if (response.success) {

                                                        row.find('td:eq(1)').text(name);
                                                        row.find('td:eq(2)').text(email);
                                                        row.find('td:eq(3)').text(address);
                                                        row.find('td:eq(4)').text(tel);

                                                        row.find('td:eq(5)').html
                                                            (
                                                                `<a class="editUser text-info mr-2" data-id="${id}">
                                                                <i class="bi bi-pencil-fill" style="color: blue"></i>
                                                                </a>`
                                                            );
                                                    } else {
                                                        alert('Cập nhật thất bại');
                                                    }
                                                },
                                                error: function () {
                                                    alert('Lỗi kết nối server!');
                                                }
                                            });


                                        }
                                    }

                                });


                            });


                            // cancel edit
                            $(document).on('click', '.cancelEdit', function (e) {
                                e.preventDefault();

                                const row = $(this).closest('tr');
                                const id = $(this).data('id');


                                loadCustomer();
                            });

                            $('#importFile').on('change', function () {
                                const file = $('#importFile')[0];
                                if (!file) return;

                                let formData = new FormData();
                                formData.append("file", file.files[0]);

                                $.ajax({
                                    url: 'importCustomer',
                                    type: 'POST',
                                    data: formData,
                                    processData: false,
                                    contentType: false,
                                    success: function (response) {
                                        if (response.success) {
                                            alert('Import thành công!');
                                            loadCustomer();
                                        } else {
                                            alert('Có dòng bị lỗi:\n' + response.errors.join('\n'));
                                            loadCustomer();
                                        }
                                    },
                                    error: function () {
                                        alert('Lỗi khi import dữ liệu!');
                                    }
                                });
                            });

                            // $('#exportBtn').on('click', function () {
                            //     let searchParams = {
                            //         name: $('#searchName').val() ?? '',
                            //         email: $('#searchEmail').val() ?? '',
                            //         status: $('#searchStatus').val() ?? '',
                            //         address: $('#searchAddress').val() ?? ''
                            //     };
                            //     console.log(searchParams);
                            //     let queryString = $.param(searchParams);
                            //     window.location.href = 'exportCustomer.action?' + queryString;
                            // });

                            $('#exportBtn').on('click', function () {
                                let searchParams = {
                                    name: $('#searchName').val().trim() || '',
                                    email: $('#searchEmail').val().trim() || '',
                                    status: $('#searchStatus').val().trim() || '',
                                    address: $('#searchAddress').val().trim() || '',
                                    page: parseInt($('#page').val()) || 1,
                                    pageSize: parseInt($('#pageSize').val()) || 20
                                };
                                console.log("Export parameters:", searchParams);

                                $.ajax({
                                    url: 'exportCustomer.action',
                                    method: 'GET',
                                    data: searchParams,
                                    xhrFields: {
                                        responseType: 'blob'
                                    },
                                    success: function (data, status, xhr) {
                                        let contentType = xhr.getResponseHeader('Content-Type');
                                        if (contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {

                                            let disposition = xhr.getResponseHeader('Content-Disposition');
                                            let filename = disposition ? disposition.split('filename=')[1].replace(/"/g, '') : 'customers.xlsx';
                                            let blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                                            let link = document.createElement('a');
                                            link.href = window.URL.createObjectURL(blob);
                                            link.download = filename;
                                            link.click();
                                        } else {

                                            data.text().then(text => {
                                                alert("Error: " + text);
                                            });
                                        }
                                    },
                                    error: function (xhr, status, error) {
                                        alert("Error exporting data: " + error);
                                    }
                                });
                            });


                        });


                    </script>