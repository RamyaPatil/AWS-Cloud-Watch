package cmpe283Project;

/**
 * Created by Varun on 4/11/2015.
 */

import com.mysql.jdbc.StringUtils;
import com.vmware.vim25.mo.*;

import java.net.URL;

public class PStatistics {
    public static String getCPUUsage(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();

                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                if( vm.getSummary().quickStats.getOverallCpuUsage() == null)
                                    return "0";
                                else
                                    return vm.getSummary().quickStats.getOverallCpuUsage().toString();
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e) {
            System.out.println("Error in getting CPU usage: "+ e.getMessage());
        }
        return "0";
    }

    public static String getMemoryUsage(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();

                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                if(!(StringUtils.isNullOrEmpty(vm.getGuest().getIpAddress()))) {
                                    return vm.getSummary().quickStats.getHostMemoryUsage().toString() + ":" + vm.getGuest().getIpAddress();
                                }
                                else {
                                    return vm.getSummary().quickStats.getHostMemoryUsage().toString() + ": No IP..Waiting!!";
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)  {
            System.out.println("Error in getting memory usage: "+ e.getMessage());
        }
        return "0";
    }

    public static String powerOffVM(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();

                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                vm.powerOffVM_Task();
                                Thread.sleep(10000);
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)  {
            System.out.println("Error in powering off VM: "+ e.getMessage());
        }
        return "0";
    }

    public static String powerOnVM(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();

                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                vm.powerOnVM_Task(h);
                                Thread.sleep(10000);
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)  {
            System.out.println("Error in powering on VM: "+ e.getMessage());
        }
        return "0";
    }

    public static String getMaxCPUUsage(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();
                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                if( vm.getRuntime().getMaxCpuUsage() == null)
                                    return "0";
                                else
                                    return vm.getRuntime().getMaxCpuUsage().toString();
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e) {
            System.out.println("Error in getting max CPU usage: "+ e.getMessage());
        }
        return "0";
    }

    public static String getMaxMemoryUsage(String vmName) {
        try {
            URL url = new URL("https://130.65.132.108/sdk");
            ServiceInstance si = new ServiceInstance(url, "administrator",
                    "12!@qwQW", true);
            ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
            for(int i=0; i<hosts.length; i++) {
                HostSystem h = (HostSystem) hosts[i];
                if (h != null) {
                    if (h.getName() != null) {
                        VirtualMachine vms[] = h.getVms();
                        for (int p = 0; p < vms.length; p++) {
                            VirtualMachine vm = vms[p];
                            if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                //temp(si,vm);
                                if( vm.getSummary().getConfig() == null)
                                    return "0";
                                else
                                    return vm.getSummary().getConfig().memorySizeMB.toString();
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)  {
            System.out.println("Error in getting max memory usage: "+ e.getMessage());
        }
        return "0";
    }
}
