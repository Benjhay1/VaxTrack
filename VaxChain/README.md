# VaxChain-Clarity: Vaccine Tracking Smart Contract

VaxChain-Clarity is a comprehensive smart contract system designed to track vaccine distribution from manufacturers to end recipients. It ensures transparency, security, and integrity throughout the vaccine supply chain while maintaining proper cold chain management and vaccination records.

## Features

### Role-Based Access Control
- Manufacturer registration and verification
- Distribution center certification
- Administrative controls for contract owner
- Clear separation of roles (manufacturer, distributor, administrator)

### Batch Management
- Unique batch identification and tracking
- Temperature requirement monitoring
- Expiration date tracking
- Status updates throughout supply chain
- Secure batch transfers between authorized entities

### Vaccination Records
- Individual vaccination tracking
- Prevention of duplicate vaccinations
- Administrator and location logging
- Complete vaccination history

### Data Validation
- String length and content validation
- Temperature requirement verification
- Expiration date checking
- Role-specific access controls
- Duplicate record prevention

## Smart Contract Structure

### Constants
```clarity
err-owner-only (err u100)
err-already-registered (err u101)
err-not-registered (err u102)
err-invalid-batch (err u103)
err-expired (err u104)
err-invalid-input (err u105)
```

### Data Maps
- `manufacturers`: Stores manufacturer information
- `vaccine-batches`: Tracks vaccine batch details
- `distribution-centers`: Manages distribution center data
- `vaccination-records`: Records individual vaccinations

### Key Functions

#### Administrative Functions
- `register-manufacturer`: Register new vaccine manufacturers
- `register-distribution-center`: Register new distribution centers

#### Batch Management
- `register-vaccine-batch`: Register new vaccine batches
- `transfer-batch`: Transfer batches between entities

#### Vaccination Records
- `record-vaccination`: Record individual vaccination events

#### Read-Only Functions
- `get-manufacturer-info`: Retrieve manufacturer details
- `get-batch-info`: Get batch information
- `get-distribution-center-info`: Get distribution center details
- `get-vaccination-record`: Retrieve vaccination records

## Security Features

1. Input Validation
   - String length checks
   - Non-empty string verification
   - Valid principal checks
   - Temperature requirement validation

2. Access Control
   - Owner-only administrative functions
   - Role-based access restrictions
   - Entity verification before operations

3. Data Integrity
   - Expiration date verification
   - Duplicate vaccination prevention
   - Batch status tracking
   - Complete audit trail

## Usage Examples

### Registering a Manufacturer
```clarity
(contract-call? .vaccine-tracking register-manufacturer "Moderna Pharmaceuticals")
```

### Registering a Vaccine Batch
```clarity
(contract-call? .vaccine-tracking register-vaccine-batch "BATCH001" "COVID-19" u1735689600 "-70°C")
```

### Recording a Vaccination
```clarity
(contract-call? .vaccine-tracking record-vaccination "BATCH001" tx-sender recipient-address)
```

## Error Handling

The contract includes comprehensive error handling:
- Invalid input validation
- Expired batch detection
- Unauthorized access prevention
- Duplicate record checking
- Role verification

## Future Enhancements

Potential improvements for future versions:
1. Multi-signature requirements for critical operations
2. Temperature logging and monitoring
3. Batch splitting functionality
4. Advanced reporting capabilities
5. Integration with IoT devices for real-time monitoring

## Testing

To run the contract tests:
1. Install Clarinet
2. Navigate to the project directory
3. Run `clarinet test`

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting pull requests.