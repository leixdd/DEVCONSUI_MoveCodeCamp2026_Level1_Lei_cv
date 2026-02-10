interface ImportMetaEnv {
  readonly VITE_PORTFOLIO_OBJECT_ID: string;
  readonly VITE_SUI_NETWORK: string;
  readonly VITE_IMAGE_URL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}