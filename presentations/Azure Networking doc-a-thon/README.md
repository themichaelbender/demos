# AI-Enhanced Documentation Repository

This repository contains resources and examples for using GitHub Copilot to enhance technical documentation processes for Azure services. The materials demonstrate practical workflows for streamlining common documentation tasks including content creation, analysis, and quality improvement.

## Overview

The resources in this repository help technical writers:

- **Create comprehensive documentation** that follows Microsoft Style Guide standards
- **Analyze existing content** for gaps, outdated information, and compliance issues  
- **Generate specialized content types** like best practices guides and FAQs
- **Perform quality assurance** through automated fact-checking and validation

## Key Resources

### [Prompts Guide](prompts.md)
The main resource containing practical prompts and workflows for using GitHub Copilot in documentation tasks. This guide covers:

#### GitHub Copilot Chat Modes
- **Ask Mode**: Converting between different command interfaces (PowerShell to Azure CLI)
- **Edit Mode**: Listing available tools and performing content transformations
- **Agent Mode**: Comprehensive article conversion with verification against Microsoft documentation

#### Documentor Extension
- Converting Word documents to Markdown
- Auto-fixing Markdown formatting
- Adding metadata and content sections
- Table of Contents (TOC) management

For more information on using the Documentor extension, refer to the [Documentor documentation](https://aka.ms/learndocumentor).

### Microsoft Learn Docs MCP Server

The Microsoft Docs MCP Server is a cloud-hosted service that enables MCP hosts like GitHub Copilot and Cursor to search and retrieve accurate information directly from Microsoft's official documentation. By implementing the standardized Model Context Protocol (MCP), this service allows any compatible AI system to ground its responses in authoritative Microsoft content.

#### Key Capabilities
- **High-Quality Content Retrieval**: Search and retrieve relevant content from Microsoft Learn, Azure documentation, Microsoft 365 documentation, and other official Microsoft sources.
- **Semantic Understanding**: Uses advanced vector search to find the most contextually relevant documentation for any query.
- **Optimized Chunking**: Returns up to 10 high-quality content chunks (each max 500 tokens), with article titles, URLs, and self-contained content excerpts.
- **Real-time Updates**: Access the latest Microsoft documentation as it's published.

For more information on the Microsoft Learn Docs MCP Server, refer to the [MCP Server documentation](https://aka.ms/docsMCP).


#### MCP Server Demonstration Scenarios

1. **Best Practices Documentation Creation**
   - Creating comprehensive best practices guides for Azure services
   - SEO and Generative Engine optimization
   - Fact-checking against current documentation

2. **Content Analysis**
   - Analyzing article counts and age in service folders
   - Identifying missing customer intent statements
   - Content quality assessment

3. **FAQ Generation**
   - Creating troubleshooting FAQs for Azure services
   - Following Microsoft style guide and best practices
   - Optimizing for search and AI engines

4. **Gap Analysis**
   - Identifying missing scenarios and articles in documentation sets
   - Analyzing customer-facing content and community resources
   - Providing recommendations with supporting references

## Getting Started

1. Review the [Prompts Guide](prompts.md) for detailed examples and workflows
2. Install the Documentor extension for GitHub Copilot (if using Word-to-Markdown conversion)
3. Familiarize yourself with the different GitHub Copilot chat modes
4. Practice with the demonstration scenarios using your own Azure service documentation

## Best Practices

- Always fact-check AI-generated content against authoritative Microsoft documentation
- Follow Microsoft Style Guide standards for all content creation
- Optimize content for both SEO and Generative Engine optimization
- Include proper metadata and customer intent statements
- Verify all code examples and commands against current Microsoft documentation

## Contributing

When adding new prompts or examples to this repository:
- Follow the established format in the prompts guide
- Include context about the intended workflow
- Provide specific examples with expected outcomes
- Test prompts thoroughly before documentation

## Additional Resources

- [Microsoft Style Guide](https://learn.microsoft.com/style-guide/)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Azure Documentation Best Practices](https://learn.microsoft.com/contribute/)
