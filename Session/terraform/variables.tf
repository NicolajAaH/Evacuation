variable path_sdu_evac_folder {
  type = string
  description = "The path to the sdu-evac folder containing Backend and Frontend."
  default = "../.."
}

variable "namespace" {

  type = string

  description = "The namespace to deploy the application to."

  default = "sdu-evac"

}