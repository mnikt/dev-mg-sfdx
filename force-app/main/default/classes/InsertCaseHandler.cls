/**
 * Created by mgieron on 07.07.2022.
 */

public class InsertCaseHandler {
    public static void updateCase (Case caseC) {
        if (caseC.Status == 'Open')
            caseC.Priority = 'Low';
        else caseC.Priority = 'Medium';
    }
}