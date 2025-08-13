# Trivy IaC Security Scanning Pipeline - Detailed Documentation

## Overview

This document provides a comprehensive explanation of each step in the Trivy Infrastructure as Code (IaC) security scanning pipeline. The pipeline is implemented using GitHub Actions and follows a security-first approach to Infrastructure as Code analysis.

## Pipeline Architecture

### Workflow Type --> CI/CD Security Scanning Pipeline
### Implementation Platform --> GitHub Actions
### Primary Purpose --> Automated security vulnerability detection in Infrastructure as Code files

## Pipeline Steps Summary

### Step 1 --> Set up job
Initialize the GitHub Actions runner environment with Ubuntu VM and required resources

### Step 2 --> Checkout code
Download repository source code to the runner environment for scanning

### Step 3 --> Clear dismissed security alerts
Reopen previously dismissed security alerts to ensure comprehensive scanning coverage

### Step 4 --> Run Trivy IaC scan
Execute primary security scan and generate SARIF format results for GitHub integration

### Step 5 --> Upload Trivy scan results to GitHub Security tab
Integrate scan results with GitHub's native security dashboard and alerting system

### Step 6 --> Run Trivy IaC scan (table format)
Generate human-readable results for immediate console review and logging

### Step 7 --> Display scan results
Show scan results directly in the pipeline execution log for immediate visibility

### Step 8 --> Archive scan results
Preserve scan results as downloadable artifacts with 30-day retention

### Step 9 --> Post Run Trivy IaC scan (table format)
Clean up resources and temporary files from table format scan execution

### Step 10 --> Post Upload Trivy scan results to GitHub Security tab
Clean up resources from SARIF upload process and finalize GitHub integration

### Step 11 --> Post Run Trivy IaC scan
Clean up resources from primary scan execution and deallocate memory

### Step 12 --> Post Checkout code
Clean up repository checkout and reset runner environment for next execution

### Step 13 --> Complete job
Finalize pipeline execution and report aggregate success/failure status

## Detailed Step-by-Step Analysis

### 1. Setup and Preparation Phase

#### Step --> Set up job
**Duration** -- 8 seconds
**Purpose** -- Initialize the GitHub Actions runner environment
**Technical Details** --
- Provisions an Ubuntu virtual machine on GitHub's infrastructure
- Allocates compute resources (CPU, memory, storage)
- Sets up the base operating system and required system packages
- Establishes network connectivity and security contexts
- Initializes environment variables and runtime configurations
**Dependencies** -- None (first step in pipeline)
**Failure Impact** -- Complete pipeline failure if this step fails

#### Step --> Checkout code
**Duration** -- 0 seconds (cached)
**Purpose** -- Download repository source code to the runner environment
**Technical Details** --
- Uses actions/checkout@v4 action from GitHub Actions marketplace
- Clones the repository content to the runner's file system
- Establishes access to all repository files and directories
- Maintains git history and metadata for potential future operations
- Sets up workspace directory structure
**Dependencies** -- Set up job completion
**Failure Impact** -- No code available for scanning, pipeline cannot proceed

### 2. Pre-Scan Management Phase

#### Step --> Clear dismissed security alerts
**Duration** -- 18 seconds
**Purpose** -- Reopen previously dismissed security alerts to ensure comprehensive scanning
**Technical Details** --
- Uses GitHub REST API through actions/github-script@v7
- Queries GitHub Security API for dismissed code scanning alerts
- Iterates through dismissed alerts and changes their state from 'dismissed' to 'open'
- Implements error handling with continue-on-error -- true
- Ensures that previously dismissed issues are not permanently hidden
- Maintains audit trail of alert state changes
**Dependencies** -- Checkout code completion, GitHub API access
**Failure Impact** -- Non-critical, pipeline continues even if this step fails

### 3. Primary Security Scanning Phase

#### Step --> Run Trivy IaC scan
**Duration** -- 9 seconds
**Purpose** -- Execute primary security scan and generate SARIF format results
**Technical Details** --
- Uses aquasecurity/trivy-action@master from Aqua Security
- Scan type configured as 'config' for Infrastructure as Code analysis
- Target scope -- example_app/learn-terraform-provision-eks-cluster directory
- Output format -- SARIF (Static Analysis Results Interchange Format)
- Severity levels -- CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN (comprehensive coverage)
- Exit code set to '0' to prevent pipeline failure on findings
- Generates trivy-iac-results.sarif file for GitHub Security integration
**Dependencies** -- Checkout code completion, Trivy tool availability
**Failure Impact** -- No SARIF results for GitHub Security tab integration

### 4. Security Integration Phase

#### Step --> Upload Trivy scan results to GitHub Security tab
**Duration** -- 6 seconds
**Purpose** -- Integrate scan results with GitHub's native security features
**Technical Details** --
- Uses github/codeql-action/upload-sarif@v3 action
- Uploads SARIF formatted results to GitHub Security dashboard
- Creates unique category using github.run_number for each execution
- Enables security alert creation and management through GitHub UI
- Supports security team workflows and notification systems
- Conditional execution with 'if -- always()' ensures execution even after failures
**Dependencies** -- SARIF file generation from primary scan
**Failure Impact** -- Security results not visible in GitHub Security tab

### 5. Secondary Analysis Phase

#### Step --> Run Trivy IaC scan (table format)
**Duration** -- 7 seconds
**Purpose** -- Generate human-readable results for immediate console review
**Technical Details** --
- Identical scanning configuration to primary scan
- Output format changed to 'table' for human readability
- Same target scope and severity levels as primary scan
- Generates trivy-iac-results.txt file for console display
- Provides immediate feedback in pipeline execution logs
**Dependencies** -- Checkout code completion, Trivy tool availability
**Failure Impact** -- No human-readable results in pipeline logs

### 6. Results Display Phase

#### Step --> Display scan results
**Duration** -- 0 seconds
**Purpose** -- Show scan results directly in the pipeline execution log
**Technical Details** --
- Executes shell commands to read and display results file
- Implements conditional logic to handle missing results files
- Provides immediate visibility into security findings
- Uses 'if -- always()' to ensure execution regardless of previous step outcomes
- Outputs formatted security findings to GitHub Actions console
**Dependencies** -- Table format scan completion
**Failure Impact** -- No immediate visibility of results in pipeline logs

### 7. Artifact Management Phase

#### Step --> Archive scan results
**Duration** -- 1 second
**Purpose** -- Preserve scan results as downloadable artifacts
**Technical Details** --
- Uses actions/upload-artifact@v4 for artifact management
- Archives both SARIF and text format results
- Sets retention period to 30 days for compliance and analysis
- Creates downloadable artifacts accessible through GitHub Actions UI
- Enables offline analysis and integration with external tools
- Conditional execution ensures artifacts are saved even after failures
**Dependencies** -- Scan result file generation
**Failure Impact** -- No downloadable artifacts for offline analysis

### 8. Post-Execution Cleanup Phase

#### Step --> Post Run Trivy IaC scan (table format)
**Duration** -- 8 seconds
**Purpose** -- Clean up resources and temporary files from table format scan
**Technical Details** --
- Automatically executed cleanup phase for Trivy action
- Removes temporary files and clears memory allocations
- Ensures proper resource deallocation
- Prevents resource leaks and maintains runner performance

#### Step --> Post Upload Trivy scan results to GitHub Security tab
**Duration** -- 1 second
**Purpose** -- Clean up resources from SARIF upload process
**Technical Details** --
- Cleanup operations for CodeQL action
- Finalizes GitHub Security integration
- Ensures proper API connection closure

#### Step --> Post Run Trivy IaC scan
**Duration** -- 0 seconds
**Purpose** -- Clean up resources from primary scan execution
**Technical Details** --
- Final cleanup for primary Trivy scan process
- Memory and temporary file cleanup
- Resource deallocation

#### Step --> Post Checkout code
**Duration** -- 8 seconds
**Purpose** -- Clean up repository checkout and associated resources
**Technical Details** --
- Removes cloned repository files from runner
- Clears git metadata and temporary files
- Resets file system permissions
- Ensures clean state for subsequent pipeline executions

#### Step --> Complete job
**Duration** -- 0 seconds
**Purpose** -- Finalize pipeline execution and report status
**Technical Details** --
- Final status reporting to GitHub Actions system
- Aggregate success/failure status determination
- Cleanup of remaining system resources
- Pipeline execution summary generation

## Technical Configuration Details

### Trigger Conditions
- Push events to 'main' and 'develop' branches
- Pull request events targeting 'main' branch
- Manual workflow dispatch for on-demand execution

### Permissions and Security
- contents -- read --> Repository file access
- security-events -- write --> GitHub Security tab integration
- actions -- read --> Workflow metadata access

### Runner Environment
- Operating System -- Ubuntu Latest (GitHub-hosted)
- Resource Allocation -- Standard GitHub Actions runner specifications
- Network Access -- Full internet connectivity for tool downloads

### Error Handling Strategy
- Non-critical steps use continue-on-error -- true
- Critical security scanning steps must complete successfully
- Cleanup operations execute regardless of previous step outcomes

### Output Formats and Integration
- SARIF format for GitHub Security dashboard integration
- Table format for immediate human readability
- Artifact storage for offline analysis and compliance
- Console output for real-time monitoring

## Best Practices Implemented

### Security Scanning Coverage
- Comprehensive severity level inclusion (CRITICAL through UNKNOWN)
- Multi-format output generation for different use cases
- Persistent artifact storage for audit trails

### Pipeline Reliability
- Conditional execution prevents unnecessary failures
- Comprehensive cleanup prevents resource leaks
- Error handling ensures partial success scenarios

### Integration and Usability
- GitHub Security tab integration for team collaboration
- Manual trigger capability for on-demand scanning
- Unique categorization prevents alert conflicts

## Monitoring and Observability

### Execution Metrics
- Step-by-step timing for performance optimization
- Success/failure status for each pipeline component
- Resource utilization tracking through GitHub Actions

### Result Accessibility
- GitHub Security dashboard for security team workflows
- Downloadable artifacts for compliance and analysis
- Console logs for immediate developer feedback

### Alert Management
- Automatic reopening of dismissed alerts
- Unique categorization for proper alert lifecycle management
- Integration with GitHub notification systems
