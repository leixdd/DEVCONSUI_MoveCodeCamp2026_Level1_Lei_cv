interface ImportMetaEnv {
  readonly VITE_PORTFOLIO_OBJECT_ID: string;
  readonly VITE_SUI_NETWORK: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}