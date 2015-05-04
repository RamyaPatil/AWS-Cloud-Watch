package cmpe283Project;

/**
 * Created by Varun on 4/11/2015.
 */
import com.vmware.vim25.*;
import com.vmware.vim25.mo.*;

import java.rmi.RemoteException;

public class VMTemplate {
    public static String ubuTemplate = "T08-TPLATE01-Ubu";
    public static String winTemplate = "T08-TPLATE-Win";

    public static boolean createVMFromTemplate(Folder vmFolder, ResourcePool rp, HostSystem hs, String vmName) throws RemoteException {
        ManagedEntity[] me = new InventoryNavigator(vmFolder).searchManagedEntities("VirtualMachine");
        if(me==null || me.length ==0) {
            System.out.println("No Virtual Machines Available");
            return false;
        }

        for(int i=0;i<me.length;i++) {
            VirtualMachine vm = (VirtualMachine) me[i];
            System.out.println("The names of the virtual machines is ==> "+vm.getName());
            System.out.println("Is the virtual machine with name " + vm.getName() + " has a template:" + vm.getConfig().template);
            if(vm.getConfig().template && vm.getName().equals(ubuTemplate) && vmName.contains("Ubu")) {
                try {
                    System.out.println("Creating VM from Template.. Please wait!..");

                    VirtualMachineCloneSpec cloneSpec = new VirtualMachineCloneSpec();
                    VirtualMachineRelocateSpec relocSpec = new VirtualMachineRelocateSpec();

                    relocSpec.setPool(rp.getMOR());

                    cloneSpec.setLocation(relocSpec);
                    cloneSpec.setPowerOn(true);
                    cloneSpec.setTemplate(false);
                    String clonedName = vmName;

                    Task cloneTask = vm.cloneVM_Task(vmFolder, clonedName, cloneSpec);

                    String result = cloneTask.waitForMe();
                    if (result == Task.SUCCESS) {
                        System.out.println("VM Created Successfully");
                        //VirtualMachine me1=(VirtualMachine) new InventoryNavigator(vmFolder).searchManagedEntity("VirtualMachine",vmName);
                        //return me1.getGuest().ipAddress;
                        return true;
                    }
                    else {
                        System.out.println("VM Creation failed");
                        return false;
                    }
                } catch (VmConfigFault e) {
                    e.printStackTrace();
                } catch (FileFault e) {
                    e.printStackTrace();
                } catch (InvalidState e) {
                    e.printStackTrace();
                } catch (InvalidDatastore e) {
                    e.printStackTrace();
                } catch (RuntimeFault e) {
                    e.printStackTrace();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                System.out.println("Template was converted to VM");
            }
            else if(vm.getConfig().template && vm.getName().equals(winTemplate) && vmName.contains("Win")) {
                try {
                    System.out.println("Creating VM from Template.. Please wait!..");

                    VirtualMachineCloneSpec cloneSpec = new VirtualMachineCloneSpec();
                    VirtualMachineRelocateSpec relocSpec = new VirtualMachineRelocateSpec();

                    relocSpec.setPool(rp.getMOR());

                    cloneSpec.setLocation(relocSpec);
                    cloneSpec.setPowerOn(true);
                    cloneSpec.setTemplate(false);
                    String clonedName = vmName;

                    Task cloneTask = vm.cloneVM_Task(vmFolder, clonedName, cloneSpec);

                    String result = cloneTask.waitForMe();
                    if (result == Task.SUCCESS) {
                        System.out.println("VM Created Successfully");
                        //VirtualMachine me1=(VirtualMachine) new InventoryNavigator(vmFolder).searchManagedEntity("VirtualMachine",vmName);
                        //return me1.getGuest().ipAddress;
                        return true;
                    }
                    else {
                        System.out.println("VM Creation failed");
                        return false;
                    }
                } catch (VmConfigFault e) {
                    e.printStackTrace();
                } catch (FileFault e) {
                    e.printStackTrace();
                } catch (InvalidState e) {
                    e.printStackTrace();
                } catch (InvalidDatastore e) {
                    e.printStackTrace();
                } catch (RuntimeFault e) {
                    e.printStackTrace();
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                System.out.println("Template was converted to VM");
            }
        }
        return false;
    }
}
