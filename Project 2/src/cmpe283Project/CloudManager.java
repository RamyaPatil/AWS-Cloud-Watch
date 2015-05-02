package cmpe283Project;

/**
 * Created by Varun on 4/11/2015.
 */
import com.vmware.vim25.VirtualDeviceConfigSpec;
import com.vmware.vim25.VirtualMachineConfigSpec;
import com.vmware.vim25.VirtualMachineFileInfo;
import com.vmware.vim25.mo.*;

import java.net.URL;

public class CloudManager {
    String dcName = "T08-DC";
    static int cpuCount = 1;
    static String guestOsId = "windows7_64Guest";
    static String diskMode = "persistent";
    static String datastoreName = "nfs4team08";
    static String netName = "VM Network";
    static String nicName = "Network Adapter 1";

    public static boolean myVMCreation(String vmName) throws Exception {
        ServiceInstance si = new ServiceInstance(new URL("https://130.65.132.108/sdk"), "administrator", "12!@qwQW", true);
        Folder rootFolder = si.getRootFolder();
        String name = rootFolder.getName();
        System.out.println("root:" + name);

        ManagedEntity[] ves = new InventoryNavigator(rootFolder).searchManagedEntities("VirtualMachine");
        ManagedEntity[] hes = new InventoryNavigator(rootFolder).searchManagedEntities("HostSystem");
        ManagedEntity[] res = new InventoryNavigator(rootFolder).searchManagedEntities("ResourcePool");
        ManagedEntity des[] = new InventoryNavigator(rootFolder).searchManagedEntities("Datacenter");

        Datacenter dc = (Datacenter) des[0];
        ResourcePool rp = (ResourcePool) new InventoryNavigator(dc.getHostFolder()).searchManagedEntities("ResourcePool")[0];
        Folder vmFolder = dc.getVmFolder();
        System.out.println("VM folder name" + vmFolder.getName());

        HostSystem hs = (HostSystem) hes[0];
        return VMTemplate.createVMFromTemplate(vmFolder, rp, hs, vmName);
    }

    public static boolean myScratchVMCreation(String vmName, long diskSizeInKB, long memorySizeInMB) throws Exception {
        ServiceInstance si = new ServiceInstance(new URL("https://130.65.132.108/sdk"), "administrator", "12!@qwQW", true);
        Folder rootFolder = si.getRootFolder();
        String name = rootFolder.getName();
        System.out.println("root:" + name);

        ManagedEntity[] ves = new InventoryNavigator(rootFolder).searchManagedEntities("VirtualMachine");
        ManagedEntity[] hes = new InventoryNavigator(rootFolder).searchManagedEntities("HostSystem");
        ManagedEntity[] res = new InventoryNavigator(rootFolder).searchManagedEntities("ResourcePool");
        ManagedEntity des[] = new InventoryNavigator(rootFolder).searchManagedEntities("Datacenter");

        Datacenter dc = (Datacenter) des[0];
        ResourcePool rp = (ResourcePool) new InventoryNavigator(dc.getHostFolder()).searchManagedEntities("ResourcePool")[0];
        Folder vmFolder = dc.getVmFolder();
        System.out.println("VM folder name" + vmFolder.getName());

        HostSystem hs = (HostSystem) hes[0];


        VirtualMachineConfigSpec vmSpec = new VirtualMachineConfigSpec();
        vmSpec.setName(vmName);
        vmSpec.setAnnotation("VirtualMachine Annotation");
        vmSpec.setMemoryMB(memorySizeInMB);
        vmSpec.setNumCPUs(cpuCount);
        vmSpec.setGuestId(guestOsId);

        int cKey = 1000;
        VirtualDeviceConfigSpec scsiSpec = VMachine.createScsiSpec(cKey);
        VirtualDeviceConfigSpec diskSpec = VMachine.createDiskSpec(datastoreName, cKey, diskSizeInKB, diskMode);
        VirtualDeviceConfigSpec nicSpec;
        nicSpec = VMachine.createNicSpec(netName, nicName);
        vmSpec.setDeviceChange(new VirtualDeviceConfigSpec[] { scsiSpec, diskSpec, nicSpec });

        VirtualMachineFileInfo vmfi = new VirtualMachineFileInfo();
        vmfi.setVmPathName("[" + datastoreName + "]");
        vmSpec.setFiles(vmfi);

        return VMachine.createVM(vmFolder, vmSpec, rp, hs);
    }

    public static String getPowerStatus(String vmName) throws Exception {
        URL url = new URL("https://130.65.132.108/sdk");
        ServiceInstance si = new ServiceInstance(url, "administrator",
                "12!@qwQW", true);
        ManagedEntity[] hosts = new InventoryNavigator(si.getRootFolder()).searchManagedEntities("HostSystem");
        for(int i=0; i<hosts.length; i++){
            HostSystem h = (HostSystem) hosts[i];
            if(h != null) {
                if (h.getName() != null) {
                    VirtualMachine vms[] = h.getVms();

                    for (int p = 0; p < vms.length; p++) {
                        VirtualMachine vm = vms[p];
                        if (vm != null && vm.getName().equalsIgnoreCase(vmName)) {
                                return vm.getRuntime().getPowerState().name();
                        }
                    }
                }
            }
        }
        return null;
    }
}