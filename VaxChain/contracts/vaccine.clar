(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-registered (err u102))
(define-constant err-invalid-batch (err u103))
(define-constant err-expired (err u104))

;; Data structures
(define-map manufacturers 
    principal 
    {name: (string-ascii 50), 
     registration-date: uint,
     active: bool})

(define-map vaccine-batches 
    (tuple (manufacturer principal) (batch-id (string-ascii 32)))
    {vaccine-type: (string-ascii 32),
     manufacture-date: uint,
     expiry-date: uint,
     temperature-requirements: (string-ascii 32),
     current-location: principal,
     status: (string-ascii 20)})

(define-map distribution-centers
    principal
    {name: (string-ascii 50),
     location: (string-ascii 100),
     certification: (string-ascii 32)})

(define-map vaccination-records
    (tuple (recipient principal) (batch-id (string-ascii 32)))
    {vaccine-type: (string-ascii 32),
     vaccination-date: uint,
     administrator: principal,
     location: principal})

;; Administrative functions
(define-public (register-manufacturer (name (string-ascii 50)))
    (let ((caller tx-sender))
        (asserts! (is-eq contract-owner caller) err-owner-only)
        (asserts! (is-none (get-manufacturer-info caller)) err-already-registered)
        (ok (map-set manufacturers
            caller
            {name: name,
             registration-date: block-height,
             active: true}))))

(define-public (register-distribution-center 
    (name (string-ascii 50))
    (location (string-ascii 100))
    (certification (string-ascii 32)))
    (let ((caller tx-sender))
        (asserts! (is-eq contract-owner caller) err-owner-only)
        (ok (map-set distribution-centers
            caller
            {name: name,
             location: location,
             certification: certification}))))

;; Batch management functions
(define-public (register-vaccine-batch
    (batch-id (string-ascii 32))
    (vaccine-type (string-ascii 32))
    (expiry-date uint)
    (temperature-req (string-ascii 32)))
    (let ((manufacturer tx-sender))
        (asserts! (is-some (get-manufacturer-info manufacturer)) err-not-registered)
        (ok (map-set vaccine-batches
            {manufacturer: manufacturer, batch-id: batch-id}
            {vaccine-type: vaccine-type,
             manufacture-date: block-height,
             expiry-date: expiry-date,
             temperature-requirements: temperature-req,
             current-location: manufacturer,
             status: "manufactured"}))))

(define-public (transfer-batch
    (batch-id (string-ascii 32))
    (manufacturer principal)
    (recipient principal))
    (let ((batch (unwrap! (get-batch-info manufacturer batch-id) err-invalid-batch))
         (current-time block-height))
        (asserts! (< current-time (get expiry-date batch)) err-expired)
        (asserts! (is-some (get-distribution-center-info recipient)) err-not-registered)
        (ok (map-set vaccine-batches
            {manufacturer: manufacturer, batch-id: batch-id}
            (merge batch {current-location: recipient, 
                         status: "in-distribution"})))))

;; Vaccination record functions
(define-public (record-vaccination
    (batch-id (string-ascii 32))
    (manufacturer principal)
    (recipient principal))
    (let ((batch (unwrap! (get-batch-info manufacturer batch-id) err-invalid-batch))
         (current-time block-height))
        (asserts! (< current-time (get expiry-date batch)) err-expired)
        (ok (map-set vaccination-records
            {recipient: recipient, batch-id: batch-id}
            {vaccine-type: (get vaccine-type batch),
             vaccination-date: current-time,
             administrator: tx-sender,
             location: (get current-location batch)}))))

;; Read-only functions
(define-read-only (get-manufacturer-info (manufacturer principal))
    (map-get? manufacturers manufacturer))

(define-read-only (get-batch-info (manufacturer principal) (batch-id (string-ascii 32)))
    (map-get? vaccine-batches {manufacturer: manufacturer, batch-id: batch-id}))

(define-read-only (get-distribution-center-info (center principal))
    (map-get? distribution-centers center))

(define-read-only (get-vaccination-record 
    (recipient principal) 
    (batch-id (string-ascii 32)))
    (map-get? vaccination-records {recipient: recipient, batch-id: batch-id}))