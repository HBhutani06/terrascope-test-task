resource "aws_efs_file_system" "efs" {
  creation_token   = var.efs_name     # Unique name for the EFS
  performance_mode = "generalPurpose" # Performance mode for the file system
  throughput_mode  = "bursting"       # Throughput mode for the file system
  encrypted        = true             # Enable encryption at rest

  tags = {
    Name        = "efs-for-eks"   # Name of the EFS
    Environment = var.environment # Environment tag
    Terraform   = "true"          # Terraform tag
  }
}

#EFS Security Group
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group" # Name of the security group
  description = "Allow NFS access"   # Description of the security group
  vpc_id      = var.vpc_id           # Attach to the VPC

  # Allow NFS access from EKS nodes
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_block # CIDR block for the VPC
  }
  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "efs-security-group" # Name of the security group
    Environment = var.environment      # Environment tag
  }
}

#EFS Mount Targets
resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.subnet_ids)         # Create mount targets in each subnet
  file_system_id  = aws_efs_file_system.efs.id     # Attach to the EFS file system
  subnet_id       = var.subnet_ids[count.index]    # Subnet for the mount target
  security_groups = [aws_security_group.efs_sg.id] # Attach the security group
}
