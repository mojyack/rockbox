#pragma once
#include "usb_core.h"
#include "usb_class_driver.h"

extern struct usb_class_driver_ep_allocation usb_iap_ep_allocs[2];

int  usb_iap_request_endpoints(struct usb_class_driver*);
int  usb_iap_set_first_interface(int interface);
int  usb_iap_get_config_descriptor(unsigned char* dest, int max_packet_size);
void usb_iap_init_connection(void);
bool usb_iap_set_alt_interface(int interface, int alt);
int usb_iap_get_alt_interface(int interface);
void usb_iap_init(void);
void usb_iap_disconnect(void);
void usb_iap_transfer_complete(int ep, int dir, int state, int length);
bool usb_iap_fast_transfer_complete(int ep, int dir, int status, int length);
bool usb_iap_control_request(struct usb_ctrlrequest* req, void* reqdata, unsigned char* dest);
int usb_iap_set_interface(int intf, int alt);
int usb_iap_get_interface(int intf);
int usb_iap_get_max_packet_size(int ep);
void usb_iap_notify_event(intptr_t data);
