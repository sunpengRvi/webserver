#output "public_ip" {
#  value = aws_instance.example.public_ip
#  description = "The public IP address of the web server"
#}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}