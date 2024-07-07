import React, { FunctionComponent } from 'react';
import { Outlet } from 'react-router-dom';
import { UserAvatar } from '@/common/components/atoms/UserAvatar/UserAvatar';
import { DateRangePicker } from '@/common/components/molecules/DateRangePicker/DateRangePicker';
import { useHomeLogic } from '@/common/hooks/useHomeLogic/useHomeLogic';
import { t } from 'i18next';
import { NotFoundRedirect } from '@/pages/NotFound/NotFound';
import { FullScreenLoader } from '@/common/components/molecules/FullScreenLoader/FullScreenLoader';

export const Home: FunctionComponent = () => {
  const {
    onDateRangeChange,
    from,
    to,
    firstName,
    fullName,
    avatarUrl,
    statisticsLink,
    workflowsLink,
    defaultTabValue,
    isLoadingCustomer,
    isExample,
    isDemo,
  } = useHomeLogic();

  if (isLoadingCustomer) {
    return <FullScreenLoader />;
  }

  if (!isLoadingCustomer && !isExample && !isDemo) {
    return <NotFoundRedirect />;
  }

  return (
    <div className={`flex flex-col gap-10 p-10`}>
      <div className={`flex items-center justify-between`}>
        <div className={`flex items-center`}>
          <UserAvatar
            fullName={fullName ?? ''}
            className={`mr-2 d-6`}
            avatarUrl={avatarUrl ?? undefined}
          />
          <h3 className={`flex max-w-[45ch] break-all text-2xl font-semibold`}>
            {t(`home.greeting`)}
            {firstName && ` ${firstName}`}
          </h3>
        </div>
        <DateRangePicker
          onChange={onDateRangeChange}
          value={{ from: from ? new Date(from) : undefined, to: to ? new Date(to) : undefined }}
        />
      </div>
      <div>
        {/*<Tabs defaultValue={defaultTabValue} key={defaultTabValue}>*/}
        {/*  <TabsList>*/}
        {/*    <TabsTrigger asChild value={statisticsLink}>*/}
        {/*      <NavLink to={statisticsLink}>Statistics</NavLink>*/}
        {/*    </TabsTrigger>*/}
        {/*    <TabsTrigger asChild value={workflowsLink}>*/}
        {/*      <NavLink to={workflowsLink}>Workflows</NavLink>*/}
        {/*    </TabsTrigger>*/}
        {/*  </TabsList>*/}
        {/*  <TabsContent value={defaultTabValue}>*/}
        {/*    <Outlet />*/}
        {/*  </TabsContent>*/}
        {/*</Tabs>*/}
        <Outlet />
      </div>
    </div>
  );
};