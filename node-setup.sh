#!/bin/bash

curl -s https://raw.githubusercontent.com/CryptoBuroMaster/logo/main/logo.sh | bash
sleep 5

# Function to print info messages
print_info() {
    echo -e "\e[32m[INFO] $1\e[0m"
}

# Function to print error messages
print_error() {
    echo -e "\e[31m[ERROR] $1\e[0m"
}






# Function to install dependencies (Rust in this case)
install_dependency() {
    print_info "<=========== Install Dependency ==============>"
    print_info "Updating and upgrading system packages, and installing curl..."
    sudo apt update && sudo apt upgrade -y && sudo apt install curl wget -y

    # Check if Docker is already installed
    if ! command -v docker &> /dev/null; then
        print_info "Docker is not installed. Installing Docker..."
        sudo apt install docker.io -y

        # Check for installation errors
        if [ $? -ne 0 ]; then
            print_error "Failed to install Docker. Please check your system for issues."
            exit 1
        fi
    else
        print_info "Docker is already installed."
    fi

    # Check if Rust is already installed
    if command -v rustc &> /dev/null; then
        print_info "Rust is already installed. Skipping installation."
    else
        print_info "Rust is not installed. Installing Rust..."
        
        # Install Rust
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        
        if [ $? -eq 0 ]; then
            print_info "Rust installed successfully."
            # Add Rust to the current shell session
            source "$HOME/.cargo/env"
        else
            print_error "Failed to install Rust."
            exit 1
        fi
    fi

    # Print Docker and Docker Compose versions to confirm installation
    print_info "Checking Docker version..."
    docker --version

    print_info "Checking Rust version..."
    rustc --version

    # Call the uni_menu function to display the menu
    node_menu

}



# Function to setup the Odyssey node
setup_node() {
    print_info "<=========== Setup the Odyssey node ==============>"
    print_info "Cloning the Odyssey repository..."
    
    # Clone the Odyssey repository
    git clone https://github.com/ithacaxyz/odyssey
    
    if [ $? -eq 0 ]; then
        print_info "Repository cloned successfully."
    else
        print_error "Failed to clone the repository."
        exit 1
    fi

    # Change directory to odyssey
    cd odyssey || { print_error "Failed to enter 'odyssey' directory."; exit 1; }

    # Install Odyssey using cargo
    print_info "Installing Odyssey binary using cargo..."
    cargo install --path bin/odyssey

    if [ $? -eq 0 ]; then
        print_info "Odyssey installed successfully."
    else
        print_error "Failed to install Odyssey."
        exit 1
    fi

    # Call the uni_menu function to display the menu
    node_menu
}





# Function to display menu and handle user input
node_menu() {
    print_info "====================================="
    print_info "  Ithaca Odyssey Node Tool Menu   "
    print_info "====================================="
    print_info ""
    print_info "1. Install-Dependencies"
    print_info "2. Setup-Node"
    print_info "3. Exit"
    print_info ""
    print_info "==============================="
    print_info " Created By : CryptoBuroMaster "
    print_info "==============================="
    print_info ""  

    # Prompt the user for input
    read -p "Enter your choice (1, 2, or 3): " user_choice
    
    # Handle user input
    case $user_choice in
        1)
            install_dependency
            ;;
        2)
            setup_node
            ;;
        3)
            print_info "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please enter 1, 2, or 3."
            node_menu # Re-prompt if invalid input
            ;;
    esac
}

# Call the node_menu function
node_menu
