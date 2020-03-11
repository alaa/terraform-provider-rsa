package main

import (
	"crypto/x509"
	"encoding/pem"
	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"log"
)

func resourcePublicKey() *schema.Resource {
	return &schema.Resource{
		Create: resourcePublicKeyCreate,
		Read:   resourcePublicKeyRead,
		Update: resourcePublicKeyUpdate,
		Delete: resourcePublicKeyDelete,

		Schema: map[string]*schema.Schema{
			"private_key": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}

func resourcePublicKeyCreate(d *schema.ResourceData, m interface{}) error {
	block, _ := pem.Decode([]byte(d.Get("private_key").(string)))

	if block == nil || block.Type != "RSA PRIVATE KEY" {
		log.Fatal("Failed to decode PEM block containing public key")
	}

	key, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		log.Fatal(err)
	}

	publicKeyDer := x509.MarshalPKCS1PublicKey(&key.PublicKey)
	pubKeyBlock := pem.Block{
		Type:    "PUBLIC KEY",
		Headers: nil,
		Bytes:   publicKeyDer,
	}

	pubKeyPem := string(pem.EncodeToMemory(&pubKeyBlock))
	d.SetId(pubKeyPem)

	resourcePublicKeyRead(d, m)
	return nil
}

func resourcePublicKeyRead(d *schema.ResourceData, m interface{}) error {
	return nil
}

func resourcePublicKeyUpdate(d *schema.ResourceData, m interface{}) error {
	return resourcePublicKeyRead(d, m)
}

func resourcePublicKeyDelete(d *schema.ResourceData, m interface{}) error {
	return nil
}
