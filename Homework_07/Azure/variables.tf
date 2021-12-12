#variable "location"{
#    type = string
#}

variable "zones" {
    type = list(string)
    default = [1,2]
}
