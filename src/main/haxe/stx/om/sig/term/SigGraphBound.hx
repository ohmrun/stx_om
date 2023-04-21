package stx.om.sig.term;

typedef SigGraphBound = Signature<{ name : Ident, data : Signature<Cell<SigGraphBound>> }>;