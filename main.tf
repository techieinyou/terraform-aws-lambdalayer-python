locals {
  python_runtimes   = ["python3.12", "python3.11", "python3.10", "python3.9", "python3.8"]
  lambda_layer_name = (var.layer_name == "null") ? "lib-python-${var.library_name}" : var.layer_name
  lambda_runtime    = contains(local.python_runtimes, var.python_runtime) ? var.python_runtime : local.python_runtimes[0]
}

locals {
  temp_folder      = "lambdalayer"
  package_source   = "${local.temp_folder}\\${var.library_name}\\python"
  package_file     = "${local.temp_folder}\\python-${var.library_name}.zip"
  folder_2_install = "${local.temp_folder}\\${var.library_name}\\python\\lib\\${var.python_runtime}\\site-packages"
  file_2_verify    = "${local.folder_2_install}\\foo.bar"
}

# create folders and a dummy file
resource "local_file" "foo_bar" {
  content  = "foo!"
  filename = local.file_2_verify
}

# waiting to get the folders and dummy file created
resource "time_sleep" "until_folder_creation" {
  depends_on      = [local_file.foo_bar]
  create_duration = "1s"
}

# installing python library
resource "null_resource" "install_python_library" {

  depends_on = [time_sleep.until_folder_creation]

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand(local.package_file)) ? 0 : 1

  # install Python library
  provisioner "local-exec" {
    command = "pip3 install ${var.library_name} -t ${local.folder_2_install}"
  }
}

# waiting until library installation completes
resource "time_sleep" "until_install_completion" {
  depends_on      = [null_resource.install_python_library]
  create_duration = "10s"
}

# create package zip file to create lambda layer
resource "null_resource" "create_package" {

  depends_on = [time_sleep.until_install_completion]

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(pathexpand(local.package_file)) ? 0 : 1

  # create package of library folder
  provisioner "local-exec" {
    command = "python -m zipfile -c ${local.package_file} ${local.package_source}"
  }
}

# creates lambda layer
resource "aws_lambda_layer_version" "python_library" {
  depends_on          = [null_resource.create_package]
  filename            = local.package_file
  layer_name          = local.lambda_layer_name
  compatible_runtimes = [var.python_runtime]
}
