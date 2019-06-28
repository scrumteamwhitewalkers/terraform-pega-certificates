############################
# eks/aks/gke  #
############################
variable kubernetes_provider {}

############################
# eks/aks/gke cluster name #
############################
variable name {}

################
# Route53 zone #
################
variable route53_zone {}

############
# ELB zone #
############
variable elb_zone_id {}

####################################################
# ELB Hostname that needs to be created in Route53 #
####################################################
variable hostname {}
