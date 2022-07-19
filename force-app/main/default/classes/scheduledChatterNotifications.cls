/**
 * Created by mgieron on 14.07.2022.
 */

public with sharing class scheduledChatterNotifications implements Schedulable {

    public void execute(SchedulableContext schedulableContext) {
        ChatterNotificationBatchClass batch = new ChatterNotificationBatchClass();
        Database.executeBatch(batch);
    }
}