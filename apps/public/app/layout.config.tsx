import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';

/**
 * Shared layout configurations
 *
 * you can configure layouts individually from:
 * Home Layout: app/(home)/layout.tsx
 * Docs Layout: app/docs/layout.tsx
 */

export const siteName = 'Devbaytech';
export const baseUrl = 'https://devbaytech.com';
export const url = (path: string) => `${baseUrl}${path}`;
export const baseOptions: BaseLayoutProps = {
  nav: {
    title: siteName,
  },
  links: [
    {
      type: 'main',
      text: 'Home',
      url: '/',
      active: 'nested-url',
    },
    {
      type: 'main',
      text: 'Pricing',
      url: '/pricing',
      active: 'nested-url',
    },
    {
      type: 'main',
      text: 'Documentation',
      url: '/docs',
      active: 'nested-url',
    },
    {
      type: 'main',
      text: 'Articles',
      url: '/articles',
      active: 'nested-url',
    },
  ],
} as const;

export const authors = [
  {
    name: 'Devbaytech Team',
    url: 'https://devbaytech.com',
  },
];

export const getAuthor = (author?: string) => {
  return authors.find((a) => a.name === author)!;
};
