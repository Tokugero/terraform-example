# Instructions

1. Create Terraform IAM user
![Create Terraform IAM user](./assets/terraform/step1.jpg)

1. Grant Terraform IAM user access to admin everything (for now)
![Grant Terraform IAM user access to admin everything (for now)](./assets/terraform/step2.jpg)

1. Generate Terraform IAM Keys. (Ideally this would be assumed roles instead, but for demonstration purposes that is beyond this training)
![Generate Terraform IAM Keys.](./assets/terraform/step3.jpg)

1. Create .env/credentials file with AWS credentials and update backend.tf accordingly

1. Create ssh public & private keys for access later. `ssh-keygen -o -a 100 -t ed25519`
![Generate SSH Keys.](./assets/terraform/step4.jpg)
