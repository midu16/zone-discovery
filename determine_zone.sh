#!/bin/bash
#-x
##################################################################################################################################################################################
#
# Mihai I - 2019 Ö
#
# This is a script that the main scope is to automatically determine on which VLAN it is located the icinga2-client and export further as environment variable to the ansible.
#
##################################################################################################################################################################################
export DEBIAN_FRONTEND=noninteractive
##################################################################################################################################################################################
# colorful echos
##################################################################################################################################################################################
black='\E[30m'
red='\E[31m'
green='\E[32m'
yellow='\E[33m'
blue='\E[1;34m'
magenta='\E[35m'
cyan='\E[36m'
white='\E[37m'
reset_color='\E[00m'
COLORIZE=1

cecho()  {
    # Color-echo
    # arg1 = message
    # arg2 = color
    local default_msg="No Message."
    message=${1:-$default_msg}
    color=${2:-$green}
    [ "$COLORIZE" = "1" ] && message="$color$message$reset_color"
    echo -e "$message"
    return
}

echo_error()   { cecho "$*" $red          ;}
echo_fatal()   { cecho "$*" $red; exit -1 ;}
echo_warning() { cecho "$*" $yellow       ;}
echo_success() { cecho "$*" $green        ;}
echo_info()    { cecho "$*" $blue         ;}
##################################################################################################################################################################################
my_test_array=(
avl2805t
avl4068t
avl2803t
avl4082t
avl4138t
)
my_production_array=(
avl4122p
avl4133p
avl4134p
avl4121p
avl4135p
avl4136p
avl4139p
avl4163p
avl4274p
)

##################################################################################################################################################################################
echo_info "The script is extracting the icinga2_client_address:"
export icinga2_client_address=$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')
echo_success "${icinga2_client_address}"

echo_info "The script is starting to test the connection to the icinga2-TEST-satellites!"
for index_2 in "${my_test_array[@]}"; do
        echo "Icinga2-Test-Satellite: $index_2";
        nc -z $index_2.it.internal 5665;
        if [ "$?" == "0" ] && [ "$index_2" == "avl4082t" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the DMZ or Public Internet Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4138t" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the AccessNetwork Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl2803t" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Application Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4068t" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Monitoring Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl2805t" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Monitoring Zone";
        fi
        echo ""
        echo_error "The host is NOT in the same VLAN!"
        echo ""
done

sleep 2s
echo_info "The script is starting to test the connection to the icinga2-PRODUCTION-satellites!"
for index_2 in "${my_production_array[@]}"; do
        echo "Icinga2-Production-Satellite: $index_2";
        nc -z $index_2.it.internal 5665;
        if [ "$?" == "0" ] && [ "$index_2" == "avl4122p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the AccessNetwork Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4133p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the AccessNetwork Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4134p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Core Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4121p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Monitoring Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4135p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Application Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4136p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Application Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4139p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the DMZ Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4163p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the T2-Special Zone";
        elif [ "$?" == "0" ] && [ $index_2 == "avl4274p" ];
        then
                echo_success "Your host is in the same VLAN with ${index_2} and in the Public-Internet Zone";
        fi
        echo ""
        echo_error "The host is NOT in the same VLAN!"
        echo ""
done

##################################################################################################################################################################################
               
