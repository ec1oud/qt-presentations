import Lsp // depends on gq submodule being built

DocumentLSClient {
    // targetDocument and diagnosticsWanted come from the Loader that instantiates this
    document: targetDocument
    diagnosticsEnabled: diagnosticsWanted
}
