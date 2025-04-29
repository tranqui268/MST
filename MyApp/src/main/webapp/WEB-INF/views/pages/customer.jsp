<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="s" uri="/struts-tags" %>
        <%@ page import="org.example.model.Customer" %>


                <s:set var="section" value="'customer'" scope="request" />
                    <div>
                        <form id="searchForm" method="get" class="form-inline mb-2">
                            <input id="searchName" type="text" name="name" placeholder="Nhập họ tên"
                                class="form-control mr-1" />
                            <input id="searchEmail" type="text" name="email" placeholder="Nhập email"
                                class="form-control mr-1" />

                            <select id="searchStatus" name="status" class="form-control mr-1">
                                <option value="">Chọn trạng thái</option>
                                <option value="1">Đang hoạt động</option>
                                <option value="0">Tạm khóa</option>
                            </select>

                            <input id="searchAddress" type="text" name="email" placeholder="Nhập địa chỉ"
                                class="form-control mr-1" />

                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm kiếm</button>
                            <a href="#" id="clearSearchBtn" class="btn btn-secondary ml-1"><i
                                    class="bi bi-x-circle"></i> Xóa tìm</a>
                        </form>

                        <div class="mb-2">
                            <a id="btnAdd" class="btn btn-secondary ml-1"><i class="bi bi-person-fill-add"
                                    style="color: blue"></i>Thêm mới</a>
                            <!-- IMPORT -->
                            <label class="btn btn-success d-inline-block align-middle ml-1" for="importFile">
                                <i class="bi bi-upload"></i> Import CSV
                                <input type="file" id="importFile" name="file" accept=".csv, .xlsx" hidden>
                            </label>

                            <!-- EXPORT -->
                            <button id="exportBtn" class="btn btn-success ml-1">
                                <i class="bi bi-download"></i> Export CSV
                            </button>
                        </div>
                        <div class="d-flex align-items-center justify-content-end" id="total">
                                   
                        </div>

                    </div>


                    <table id="customerTable" class="table table-bordered table-striped text-center">
                        <thead class="thead-light">
                            <tr>
                                <th>#</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Địa chỉ</th>
                                <th>Điện thoại</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="customerTableBody">

                        </tbody>
                    </table>


                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="pagination">
                        </ul>
                    </nav>


                    <!-- Modal Thêm mới khách hàng -->
                    <div class="modal fade" id="addCustomerModal" tabindex="-1" role="dialog"
                        aria-labelledby="addCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addCustomerModalLabel"></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <form id="addCustomerForm">
                                        <div class="form-group">
                                            <label for="newName">Tên:</label>
                                            <input type="text" class="form-control" id="newName" name="name" required>
                                            <small class="text-danger" id="nameError"></small>
                                        </div>
                                        <div class="form-group">
                                            <label for="newEmail">Email:</label>
                                            <input type="email" class="form-control" id="newEmail" name="email"
                                                required>
                                            <small class="text-danger" id="emailError"></small>
                                        </div>
                                        <div class="form-group">
                                            <label for="newPhone">Điện thoại:</label>
                                            <input type="tel" class="form-control" id="newPhone" name="phone" required>
                                            <small class="text-danger" id="phoneError"></small>
                                        </div>
                                        <div class="form-group">
                                            <label for="newAddress">Địa chỉ:</label>
                                            <input type="text" class="form-control" id="newAddress" name="newAddress"
                                                required>
                                            <small class="text-danger" id="addressError"></small>
                                        </div>


                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                    <button type="button" class="btn btn-primary" id="saveCustomerBtn">Lưu</button>
                                </div>
                            </div>
                        </div>
                    </div>





