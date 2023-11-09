import { JSONFormElementParams } from '@app/components/organisms/UIRenderer/elements/JSONForm/JSONForm';
import { UIElement } from '@app/domains/collection-flow';
import { createContext } from 'react';

export interface JSONFormDefinitionContext {
  definition: UIElement<JSONFormElementParams>;
}

export const jsonFormDefinitionContext = createContext<JSONFormDefinitionContext>(
  {} as JSONFormDefinitionContext,
);